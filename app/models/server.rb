class Server < ActiveRecord::Base
	attr_accessible :hostname, :ip_address

	validate :must_be_unique
  
	def must_be_unique
		server_count = Server.count(:conditions => ["hostname = ? and ip_address = ?", self.hostname, self.ip_address])

		if server_count > 0
			errors.add(:base, "Cannot have more than one server with the same hostname and IP address")
		end
	end

end
