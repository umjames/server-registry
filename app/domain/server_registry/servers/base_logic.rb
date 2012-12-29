module ServerRegistry
	module Servers
		module BaseLogic
			def all_servers
				Server.order("hostname asc").all
			end

			def get_server(id)
				Server.find(id)
			end

			def new_server_with_params(params)
				Server.new(params)
			end

			def new_server_with_json(server_json_hash)
				new_server = Server.new
				new_server.hostname = server_json_hash[:hostname]
				new_server.ip_address = server_json_hash[:ip_address]
				new_server.port = server_json_hash[:port]

				if server_json_hash.has_key?(:categories)
					associate_server_with_categories(new_server, server_json_hash[:categories])
				end

				return new_server
			end

			def associate_server_with_categories(server, categories)
				categories_as_string = case categories
				when Array
					categories.join(", ")
				when String
					categories
				else
					raise "Unrecognized type for categories"
				end

				if categories.kind_of?(Array)
					categories_as_string = categories.join(", ")
				end

				server.category_list = categories_as_string
			end

			def destroy_server(server)
				server.destroy
			end
		end
	end
end