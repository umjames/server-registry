require 'test_helper'

class ServerTest < ActiveSupport::TestCase
  test "cannot create duplicates" do
  	server1 = FactoryGirl.create(:server)

  	assert !server1.new_record?, "first server is unsaved"

  	server2 = FactoryGirl.build(:server)

  	assert_equal server1.hostname, server2.hostname
  	assert_equal server1.ip_address, server2.ip_address

  	assert !server2.save, "was able to save a duplicate server"
  	assert !server2.errors.empty?
  end

  test "can update server" do
  	server1 = FactoryGirl.create(:server)

  	assert !server1.new_record?, "did not save server1"

  	server1.category_list = "test, tags"

  	assert_nothing_raised do
  		server1.save!
  	end
  end

  test "must have either a hostname or an IP address" do
  	blank_server = Server.new

  	assert blank_server.new_record?, "server is not new"
  	assert !blank_server.valid?, "blank server is valid"

  	blank_server.hostname = "test"

  	assert blank_server.valid?, "server with only hostname is not valid"

  	blank_server.hostname = nil
  	assert !blank_server.valid?, "blank server is valid after assigning hostname"

  	blank_server.ip_address = "1.2.3.4"
  	assert blank_server.valid?, "server with only IP address is not valid"

  	blank_server.ip_address = nil
  	assert !blank_server.valid?, "blank server is valid after assigning IP address"
  end

  test "servers can differ by port number" do
    server1 = FactoryGirl.create(:server)

    assert !server1.new_record?, "first server is unsaved"
    assert server1.port.nil?, "port is not nil"

    server2 = FactoryGirl.build(:server)

    assert_equal server1.hostname, server2.hostname
    assert_equal server1.ip_address, server2.ip_address
    assert server2.port.nil?, "port is not nil"

    assert !server2.valid?, "second server is valid"
    
    server2.port = 80

    assert server2.valid?, "second server is not valid"
  end
end
