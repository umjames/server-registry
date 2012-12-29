module ServerRegistry
	extend ActiveSupport::Autoload

	autoload :Categories, 'server_registry/categories'
	autoload :Servers, 'server_registry/servers'
end