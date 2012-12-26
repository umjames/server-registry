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
		end
	end
end