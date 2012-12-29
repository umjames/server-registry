module ServerRegistry
	module API
		module V1
			module JsonEntityFields
				extend ActiveSupport::Concern

				def json_fields_for(entity, options={})
		          return nil if entity.nil?

		          class_name = entity.class.name

		          if self.respond_to?("#{class_name.underscore}_fields".to_sym)
		            return self.__send__("#{class_name.underscore}_fields".to_sym, entity, options)
		          else
		            raise "#{self.class.name} does not respond to #{class_name.underscore}_fields"
		          end
		        end

		        protected

		        def collection_of_hashes_with_keys_for_entities(keys, collection)
		          return [] if collection.nil? || collection.empty?

		          result = []

		          collection.each do |item|
		            result << hash_with_keys_for_entity(keys, item)
		          end

		          return result
		        end

		        def hash_with_keys_for_entity(keys, entity)
		          return nil if entity.nil?

		          result = {}

		          keys.each do |key|
		            # replace id columns with uuids if they exist
		            if key.to_s == "id"
		              if entity.respond_to?(:uuid)
		                result[key] = entity.uuid
		                next
		              end
		            end

		            result[key] = entity.__send__(key.to_sym)
		          end

		          return result
		        end

		        def server_keys
		        	%w(hostname
		        	ip_address
		        	port)
		        end

		        def category_keys
		        	%w(name)
		        end

		        def server_fields(server, options={})
		        	json_hash = {}

		        	unless server.nil?
			        	json_hash.merge!(hash_with_keys_for_entity(server_keys, server))

			        	server_categories = server.categories.map(&:name)

				        json_hash["categories"] = server_categories
				    end

			        return json_hash
		        end

		        def category_fields(category, options={})
		        	json_hash = {}

		        	unless category.nil?
			        	json_hash.merge!(hash_with_keys_for_entity(category_keys, category))

			        	servers_in_category = Server.tagged_with(category.name)

			        	json_hash["servers"] = collection_of_hashes_with_keys_for_entities(server_keys, servers_in_category)
			        end

		        	return json_hash
		        end
			end
		end
	end
end