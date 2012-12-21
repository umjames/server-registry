class CreateServersTable < ActiveRecord::Migration
  def change
  	create_table :servers do |t|
  		t.string :hostname
  		t.string :ip_address
  		t.timestamps
  	end

  	add_index :servers, [:hostname, :ip_address], :unique => true
  end
end
