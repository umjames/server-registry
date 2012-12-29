require 'rubygems'
require 'yajl'

require File.join(File.dirname(__FILE__), "../lib/json_hash")
require File.join(File.dirname(__FILE__), "json_entity_fields")

module ServerRegistry
	module API
		module V1
			module JsonResponses
				include ServerRegistry::API::JsonHash
				include ServerRegistry::API::V1::JsonEntityFields

				def all_servers_response(servers)
					servers_as_hash = servers.map do |server|
						server_fields(server)
					end

					return jsonify(servers_as_hash)
				end

				def get_server_response(server)
					server_hash = server_fields(server)

					return jsonify(server_hash)
				end

				def all_categories_response(categories)
					categories_as_hash = categories.map do |category|
						category_fields(category)
					end

					return jsonify(categories_as_hash)
				end

				def category_with_name_response(category)
					category_hash = category_fields(category)

					return jsonify(category_hash)
				end

				def jsonify(data)
					return Yajl::Encoder.encode(data, :pretty => true)
				end
			end
		end
	end
end