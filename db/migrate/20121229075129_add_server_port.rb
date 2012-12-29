class AddServerPort < ActiveRecord::Migration
  def up
  	add_column :servers, :port, :integer
  	remove_index :servers, [:hostname, :ip_address]

  	add_index :servers, [:hostname, :ip_address, :port], :unique => true, :name => "by_all_fields"
  end

  def down
  	remove_index :servers, :name => "by_all_fields"

  	add_index :servers, [:hostname, :ip_address]
  	remove_column :servers, :port
  end
end
