require File.join(File.dirname(__FILE__), "spec_helper")

describe "v1" do
	describe "Servers API" do

		def app
			@app1
		end

		before(:each) do
			@categories = {}

			%w(memcached app_server db_master).each do |category_name|
				@categories[category_name.to_sym] = ActsAsTaggableOn::Tag.create!(:name => category_name)
			end

			@servers = []

			3.times do |number|
				server = FactoryGirl.create(:dynamic_server)
				server.category_list = "memcached, app_server"
				server.save!
				@servers << server
			end
		end

		it "should list all servers" do
			get '/servers'

			last_response.should be_ok
			json_response = Yajl::Parser.new(:symbolize_keys => true).parse(last_response.body)

			json_response.should have(@servers.length).items
			json_response.first[:categories].should == ["memcached", "app_server"]
		end
	end
end