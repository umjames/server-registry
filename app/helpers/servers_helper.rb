module ServersHelper
	def server_display_name(server)
		if server.ip_address.blank?
			return server.hostname
		else
			if server.hostname.blank?
				return server.ip_address
			else
				return "#{server.hostname} (#{server.ip_address})"
			end
		end
	end
end
