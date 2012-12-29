module ServerRegistry
	module Servers
		extend ActiveSupport::Autoload

		autoload :BaseLogic, 'server_registry/servers/base_logic'
	end
end