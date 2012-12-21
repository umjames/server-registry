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
end
