module ServerRegistry
	module API
		module JsonHash
			extend ActiveSupport::Concern

			def symbolize_keys(entity, hash_or_array)
	          result = {}

	          if hash_or_array.kind_of?(Array)
	            symbolized_array = []

	            hash_or_array.each do |item|
	              if item.kind_of?(Array)
	                symbolized_array << symbolize_keys(entity, item)
	              elsif item.kind_of?(Hash)
	                symbolized_array << symbolize_keys(entity, item)
	              elsif item.kind_of?(Time)
	                if item.utc?
	                  symbolized_array << item.strftime("%Y-%m-%d %H:%M:%S UTC")
	                else
	                  utc_value = item.gmtime
	                  symbolized_array << utc_value.strftime("%Y-%m-%d %H:%M:%S UTC")
	                end
	              else
	                symbolized_array << item
	              end
	            end

	            return symbolized_array
	          elsif hash_or_array.kind_of?(Hash)
	            hash_or_array.each_pair do |key, value|
	              if value.kind_of?(Time)
	                if value.utc?
	                  result[key.to_sym] = value.strftime("%Y-%m-%d %H:%M:%S UTC")
	                else
	                  utc_value = value.gmtime
	                  result[key.to_sym] = utc_value.strftime("%Y-%m-%d %H:%M:%S UTC")
	                  # result[key.to_sym] = value.strftime("%Y-%m-%d %H:%M:%S %z")
	                end
	              elsif value.kind_of?(Hash)
	                # recursively process hashes
	                result[key.to_sym] = symbolize_keys(entity, value)
	              elsif value.kind_of?(Array)
	                # recursively process arrays
	                result[key.to_sym] = symbolize_keys(entity, value)
	              else
	                # if entity.class.respond_to?(:ensured_for_http_scheme?)
	                #   result[key.to_sym] = entity.__send__(key.to_sym)
	                # else
	                  result[key.to_sym] = value
	                # end
	              end
	            end
	          end

	          return result
	        end
		end
	end
end