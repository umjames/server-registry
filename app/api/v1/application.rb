require 'rubygems'
require 'sinatra/base'

module ServerRegistry
	module API
		module V1
			class Application < Sinatra::Base
				get "/hello" do
					"Hello World!"
				end
			end
		end
	end
end