# API bootstrap loader
module ServerRegistry
	module API
		def self.rails_root
	      File.join(File.dirname(__FILE__), "..", "..")
	    end
	    
	    def self.api_root_dir
	      File.join(File.dirname(__FILE__))
	    end
	    
	    def self.api_version_dir(version)
	      File.join(api_root_dir, "v#{version}")
	    end
	    
	    def self.api_class
	      Thread.current[:api_class]
	    end
	    
	    def self.api_version
	      Thread.current[:api_version]
	    end
	end
end

require File.join(ServerRegistry::API.rails_root, "app", "domain", "server_registry")
require File.join(ServerRegistry::API.api_root_dir, "lib", "json_hash")
# require File.join(ServerRegistry::API.rails_root, "lib", "model_extensions")
# require File.join(ServerRegistry::API.rails_root, "lib", "process_import_methods")
# require File.join(ServerRegistry::API.rails_root, "lib", "caching_methods")
require File.join(ServerRegistry::API.api_version_dir(1), "application")
# require File.join(ServerRegistry::API.api_version_dir(2), "app")
# require File.join(ServerRegistry::API.api_version_dir(3), "app")