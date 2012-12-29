require "rubygems"
require "bundler/setup"

Bundler.require(:default, :test)

require File.join(File.dirname(__FILE__), "../../../app/api/api")

require 'sinatra'

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

RSpec.configure do |config|
	config.include(Rack::Test::Methods)
	config.around do |example|
	  # we initialize the Sinatra app here so that it picks up the test environment settings
	  @app1 = ServerRegistry::API::V1::Application.new

	  require File.join(File.dirname(__FILE__), "../../factories/servers")
	  
	  ActiveRecord::Base.transaction do
	    example.run
	    raise ActiveRecord::Rollback
	  end
	end
end