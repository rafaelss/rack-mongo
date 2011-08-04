require "rack/mongo/version"
require "mongo"
require "yajl"
require "addressable/uri"

module Rack
  class Mongo
    class ConfigurationError < Exception
    end

    def initialize(options = {})
      raise ConfigurationError, "You need to setup :db configuration in order to use Rack::Mongo" unless [ Symbol, String ].include?(options[:db].class)

      options = { :host => "localhost", :port => 27017 }.merge(options)
      @db = ::Mongo::Connection.new(options[:host], options[:port]).db(options[:db])
      @db.authenticate(options[:username], options[:password]) if options[:username] || options[:password]
    end

    def call(env)
      collection_name = env["PATH_INFO"].to_s.sub(/^\//, "")
      collection = @db.collection(collection_name)

      if env["REQUEST_METHOD"] == "POST"
        u = Addressable::URI.new
        u.query = env["rack.input"].read
        object_id = collection.insert(u.query_values)
        response(object_id, 201)
      else
        response(collection.find.to_a)
      end
    end

    private

    def response(data, status = 200)
      [ status, { "Content-Type" => "application/json" }, [ Yajl::Encoder.encode(data) ] ]
    end
  end
end

