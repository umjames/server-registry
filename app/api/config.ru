require File.join(File.dirname(__FILE__), "api")

map "/" do
	run ServerRegistry::API::V1::Application
end

map "/v1" do
	run ServerRegistry::API::V1::Application
end
