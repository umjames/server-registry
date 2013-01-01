require 'rubygems'
require 'sinatra/base'
require 'sinatra/url_for'
require 'active_support/dependencies/autoload'
require 'yajl'

require File.join(File.dirname(__FILE__), "json_responses")

module ServerRegistry
	module API
		module V1
			class Application < Sinatra::Base
				include ServerRegistry::API::SetupMethods
				include ServerRegistry::Servers::BaseLogic
				include ServerRegistry::Categories::BaseLogic
				include ServerRegistry::API::V1::JsonResponses

				SERVER_REGISTRY_ERROR_HEADER_NAME = "X-ServerRegistry-Error"

				def initialize(app=nil)
					connect_to_database
					super
				end

				helpers Sinatra::UrlForHelper

				get "/servers" do
					servers = all_servers
					json_data = all_servers_response(servers)
					ok_response_with_json_data(json_data)
				end

				get "/server/:id" do
					returning_not_found_on_record_not_found do
						server = get_server(params[:id])
						json_data = get_server_response(server)
						ok_response_with_json_data(json_data)
					end
				end

				post "/servers" do
					post_body = request.body.string

					post_json_data = parse_json(post_body)

					if post_json_data
						returning_server_error_on_invalid_save do
							new_server = new_server_with_json(post_json_data)
							pre_existing_server = new_server.pre_existing_server

							if pre_existing_server
								# update pre-existing server with specified categories (if any)
								unless post_json_data[:categories].nil?
									associate_server_with_categories(pre_existing_server, post_json_data[:categories])
									pre_existing_server.save!
									ok_response_with_resource_url(url_for("/server/:id", :full, { :id => pre_existing_server.id }))
								end
							else
								new_server.save!
								created_response(url_for("/server/:id", :full, { :id => new_server.id }))
							end
						end
					else
						halt(invalid_media_type_response("POST body must be valid JSON data"))
					end
				end

				delete "/server/:id" do
					returning_not_found_on_record_not_found do
						server = get_server(params[:id])
						destroy_server(server)
						ok_response
					end
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

				delete "/category/:category_name/server/:server_name" do
					returning_server_error_on_invalid_save do
						server = find_server_in_category_with_name(params[:category_name], params[:server_name])
						
						unless server.nil?
							disassociate_server_from_category_with_name(server, params[:category_name])
							server.save!
							ok_response
						else
							not_found_response
						end
					end
				end

				protected

				def returning_server_error_on_invalid_save(&block)
					begin
						block.call
					rescue ActiveRecord::RecordInvalid => e
						halt(internal_server_error_response(e.record.errors))
					end
				end

				def returning_not_found_on_record_not_found(&block)
					begin
						block.call
					rescue ActiveRecord::RecordNotFound => e
						halt(not_found_response)
					end
				end

				def parse_json(data)
					begin
						json = Yajl::Parser.parse(data, :symbolize_keys => true)
						return json
					rescue Yajl::ParseError => e
						return false
					end
				end

				def internal_server_error_response(error_message)
					[500, {SERVER_REGISTRY_ERROR_HEADER_NAME => error_message}, nil]
				end

				def invalid_media_type_response(error_message)
					[415, {SERVER_REGISTRY_ERROR_HEADER_NAME => error_message}, nil]
				end

				def not_found_response
					[404, {"Content-Type" => "application/json"}, nil]
				end

				def ok_response
					[200, {}, nil]
				end

				def ok_response_with_resource_url(resource_url)
					[200, {"Content-Type" => "text/plain", "Location" => resource_url}, resource_url]
				end

				def ok_response_with_json_data(json_data)
					[200, {"Content-Type" => "application/json; charset=UTF-8"}, json_data]
				end

				def created_response(new_resource_url)
					[201, {"Content-Type" => "text/plain", "Location" => new_resource_url}, new_resource_url]
				end
			end
		end
	end
end