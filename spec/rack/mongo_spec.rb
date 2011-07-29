require "spec_helper"
require "yajl"

describe Rack::Mongo do
  include Rack::Test::Methods

  def app(options = {})
    options = { :db => "test_db" }.merge(options)
    Rack::Mongo.new(options)
  end

  describe "db configuration" do
    it "should use default configuration for host and port" do
      connection = mock("Connection")
      connection.should_receive(:db).with("test_db")
      Mongo::Connection.should_receive(:new).with("localhost", 27017).and_return(connection)

      app
    end

    it "should raise an error if :db is not configured" do
      lambda { app(:db => nil) }.should raise_error(Rack::Mongo::ConfigurationError)
    end

    it "should accept custom host and port configuration" do
      connection = mock("Connection")
      connection.should_receive(:db).with("test_db")
      Mongo::Connection.should_receive(:new).with("my.custom.host", 9876).and_return(connection)

      app(:host => "my.custom.host", :port => 9876)
    end
  end

  describe "POST /people" do
    before :each do
      object_id = mock("ObjectId")
      object_id.should_receive(:to_json).and_return("{\"$oid\": \"4e31f5a97cb7243591000002\"}")
      collection = mock("Collection")
      collection.should_receive(:insert).with("first_name" => "Rafael", "last_name" => "Souza").and_return(object_id)
      db = mock("DB")
      db.should_receive(:collection).with("people").and_return(collection)
      connection = mock("Connection")
      connection.should_receive(:db).with("test_db").and_return(db)
      Mongo::Connection.should_receive(:new).with("localhost", 27017).and_return(connection)
    end

    it "should save person data in a collection called 'people'" do
      post "/people", :first_name => "Rafael", :last_name => "Souza"

      last_response.status.should == 201
      Yajl::Parser.parse(last_response.body).should == { '$oid' => "4e31f5a97cb7243591000002" }
    end
  end
end

