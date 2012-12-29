require "yaml"

module ServerRegistry
	module API
		module SetupMethods
			
			def connect_to_database
		        db_config = YAML::load(File.open(path_to_database_config))
		        # STDOUT.puts "Connecting to database using environment #{settings.environment.to_s}"
		        ActiveRecord::Base.establish_connection(db_config[settings.environment.to_s])
		    end

		    def path_to_database_config
		        File.join(ServerRegistry::API.rails_root, "config/database.yml")
		    end
		end
	end
end