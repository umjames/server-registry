require "rubygems"
require "active_support/core_ext/string/inflections"

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

def add_directory_to_load_path(dir_path)
	$LOAD_PATH.unshift(dir_path)
end

models_directory = File.join(ServerRegistry::API.rails_root, "app", "models")

add_directory_to_load_path(File.join(ServerRegistry::API.rails_root, "app", "domain"))
add_directory_to_load_path(models_directory)

# autoload models
Dir.glob(File.join(models_directory, "*.rb")).each do |model_file_name|
	truncated_name = File.basename(model_file_name, ".rb")
	autoload truncated_name.camelize.to_sym, truncated_name
end

require File.join(ServerRegistry::API.rails_root, "app", "domain", "server_registry")
require File.join(ServerRegistry::API.api_root_dir, "lib", "json_hash")
require File.join(ServerRegistry::API.api_root_dir, "lib", "setup_methods")
# require File.join(ServerRegistry::API.rails_root, "lib", "model_extensions")
# require File.join(ServerRegistry::API.rails_root, "lib", "process_import_methods")
# require File.join(ServerRegistry::API.rails_root, "lib", "caching_methods")
require File.join(ServerRegistry::API.api_version_dir(1), "application")
# require File.join(ServerRegistry::API.api_version_dir(2), "app")
# require File.join(ServerRegistry::API.api_version_dir(3), "app")