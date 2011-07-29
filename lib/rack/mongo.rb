require "rack/mongo/version"
require "mongo"

module Rack
  class Mongo
    class ConfigurationError < Exception
    end

    def initialize(options = {})
      raise ConfigurationError, "You need to setup :db configuration in order to use Rack::Mongo" unless [ Symbol, String ].include?(options[:db].class)

      options = { :host => "localhost", :port => 27017 }.merge(options)
      @db = ::Mongo::Connection.new(options[:host], options[:port]).db(options[:db])
    end

    def call(env)
      request = Rack::Request.new(env)
      collection_name = request.path_info.sub(/^\//, "")
      object_id = @db.collection(collection_name).insert(request.params)

      [201, { "Content-Type" => "application/json" }, [ object_id.to_json ]]
    end
  end
end

