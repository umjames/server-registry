require File.join(File.dirname(__FILE__), "spec_helper")

describe "v1" do
	describe "Categories API" do

		def app
			@app1
		end

		before(:each) do
			@categories = {}

			%w(memcached app_server db_master).each do |category_name|
				@categories[category_name.to_sym] = ActsAsTaggableOn::Tag.create!(:name => category_name)
			end
		end

		it "should list all categories" do
			get '/categories'

			last_response.should be_ok
			json_response = Yajl::Parser.new(:symbolize_keys => true).parse(last_response.body)

			json_response.should have(@categories.keys.length).items
		end

		it "should allow finding specific categories" do
			# associate 3 servers with memcached category
			memcached_servers = []

			3.times do |number|
				server = FactoryGirl.create(:dynamic_server)
				server.category_list = "memcached"
				server.save!

				memcached_servers << server
			end

			get '/category/memcached'

			last_response.should be_ok
			json_response = Yajl::Parser.new(:symbolize_keys => true).parse(last_response.body)

			json_response.should be_an_instance_of(Hash)
			json_response[:name].should == "memcached"
			json_response[:servers].should have(3).items
		end

		it "should report that a specific category is not found" do
			get '/category/owmfwofm'

			last_response.should_not be_ok
			last_response.should be_not_found
			last_response.body.should be_empty
		end
	end
end