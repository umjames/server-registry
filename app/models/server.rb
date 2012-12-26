class Server < ActiveRecord::Base
	attr_accessible :hostname, :ip_address

	acts_as_taggable_on :categories

	validate :must_be_unique, :must_have_hostname_or_ip_address
  
	def must_be_unique
		existing_server_ids = Server.select(:id).where("hostname = ? and ip_address = ?", self.hostname, self.ip_address).all

		if existing_server_ids.length > 0 && existing_server_ids.first.id != self.id
			errors.add(:base, "Cannot have more than one server with the same hostname and IP address")
		end
	end

	def must_have_hostname_or_ip_address
		if self.hostname.blank? && self.ip_address.blank?
			errors.add(:base, "Server must have a hostname or IP address")
		end
	end
end
