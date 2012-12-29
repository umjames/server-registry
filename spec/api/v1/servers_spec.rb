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

		it "should be able to get a single server" do
			server = @servers.sample

			get "/server/#{server.id}"

			last_response.should be_ok
			json_response = Yajl::Parser.new(:symbolize_keys => true).parse(last_response.body)

			json_response[:id].should == server.id
			json_response[:categories].should == ["memcached", "app_server"]
		end

		it "should respond properly to asking for a non-existent server" do
			get "/server/5776867"

			last_response.should be_not_found
		end

		context "adding servers" do
			before(:each) do
				@new_server_json_hash = {}

				@new_server_json_hash[:hostname] = "www.example.com"
				@new_server_json_hash[:ip_address] = "1.2.3.4"
				@new_server_json_hash[:port] = 80
				@new_server_json_hash[:categories] = ["app_server"]

				@new_server_json = Yajl::Encoder.encode(@new_server_json_hash)
			end

			it "should allow adding new servers" do
				post '/servers', @new_server_json

				last_response.status.should == 201
				location_header = last_response.headers["Location"]
				location_header.should_not be_nil

				last_response.body.should_not be_empty

				server = Server.find_by_hostname("www.example.com")
				server.should_not be_nil
				server.port.should == 80
				server.ip_address.should == "1.2.3.4"
				server.categories.first.name.should == "app_server"
			end
		end

		context "updating servers" do
			before(:each) do
				@new_server_json_hash = {}

				@new_server_json_hash[:hostname] = "www.example.com"
				@new_server_json_hash[:ip_address] = "1.2.3.4"
				@new_server_json_hash[:port] = 80
				@new_server_json_hash[:categories] = ["app_server"]

				@new_server_json = Yajl::Encoder.encode(@new_server_json_hash)
			end

			it "should allow updating existing servers" do
				post '/servers', @new_server_json

				last_response.status.should == 201

				server = Server.find_by_hostname("www.example.com")
				server.should_not be_nil
				server.port.should == 80
				server.ip_address.should == "1.2.3.4"
				server.categories.first.name.should == "app_server"

				@new_server_json_hash[:categories] = ["memcached", "db_master"]
				@new_server_json = Yajl::Encoder.encode(@new_server_json_hash)

				post '/servers', @new_server_json

				last_response.should be_ok
				location_header = last_response.headers["Location"]
				location_header.should_not be_nil

				last_response.body.should_not be_empty

				server.reload

				server.category_list.include?("memcached").should be_true
				server.category_list.include?("db_master").should be_true
			end
		end

		context "deleting servers" do
			it "should be able to delete servers" do
				server = @servers.sample

				delete "/server/#{server.id}"
				last_response.should be_ok

				get "/server/#{server.id}"
				last_response.should be_not_found
			end

			it "should not be able to delete non-existent servers" do
				delete "/server/2325454"

				last_response.should be_not_found
			end
		end
	end
end