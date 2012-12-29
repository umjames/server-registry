module ServerRegistry
	module Categories
		extend ActiveSupport::Autoload

		autoload :BaseLogic, 'server_registry/categories/base_logic'
	end
end