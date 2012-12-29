class Server < ActiveRecord::Base
	attr_accessible :hostname, :ip_address, :port

	acts_as_taggable_on :categories

	validates_numericality_of :port, :only_integer => true, :greater_than_or_equal_to => 0, :allow_nil => true
	validate :must_be_unique, :must_have_hostname_or_ip_address
  
	def must_be_unique
		existing_server_ids = Server.select(:id).where(:hostname => self.hostname, :ip_address => self.ip_address, :port => self.port).all

		if existing_server_ids.length > 0 && existing_server_ids.first.id != self.id
			errors.add(:base, "Cannot have more than one server with the same hostname, IP address, and port")
		end
	end

	def must_have_hostname_or_ip_address
		if self.hostname.blank? && self.ip_address.blank?
			errors.add(:base, "Server must have a hostname or IP address")
		end
	end
end
