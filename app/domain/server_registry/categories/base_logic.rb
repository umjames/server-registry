module ServerRegistry
	module Categories
		module BaseLogic
			def all_categories
				ActsAsTaggableOn::Tag.order("name asc").all
			end

			def all_category_names
				all_categories.map(&:name)
			end

			def get_category(id)
				ActsAsTaggableOn::Tag.find(id)
			end

			def get_category_by_name(name)
				ActsAsTaggableOn::Tag.where("name = ?", name).first
			end

			def new_category_with_params(params)
				ActsAsTaggableOn::Tag.new(params)
			end
		end
	end
end