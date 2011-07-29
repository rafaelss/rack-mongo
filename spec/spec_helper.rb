require "rack/mongo"
require "rack/test"

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|file| require file}

RSpec.configure do |config|
  # config.include Helpers
end

