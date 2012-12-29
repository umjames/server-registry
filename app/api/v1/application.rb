require 'rubygems'
require 'sinatra/base'
require 'active_support/dependencies/autoload'

require File.join(File.dirname(__FILE__), "json_responses")

module ServerRegistry
	module API
		module V1
			class Application < Sinatra::Base
				include ServerRegistry::Servers::BaseLogic
				include ServerRegistry::Categories::BaseLogic
				include ServerRegistry::API::V1::JsonResponses

				get "/servers" do
					servers = all_servers
					json_data = all_servers_response(servers)
					ok_response_with_json_data(json_data)
				end

				get "/categories" do
					categories = all_categories
					json_data = all_categories_response(categories)
					ok_response_with_json_data(json_data)
				end

				get "/category/:category_name" do
					category = get_category_by_name(params[:category_name])

					unless category.nil?
						json_data = category_with_name_response(category)
						ok_response_with_json_data(json_data)
					else
						not_found_response
					end
				end

				protected

				def not_found_response
					[404, {"Content-Type" => "application/json"}, nil]
				end

				def ok_response_with_json_data(json_data)
					[200, {"Content-Type" => "application/json; charset=UTF-8"}, json_data]
				end
			end
		end
	end
end