module ApplicationHelper
	def server_display_name(server)
		result = ""

		if server.ip_address.blank?
			result = server.hostname
		else
			if server.hostname.blank?
				result = server.ip_address
			else
				result = "#{server.hostname} (#{server.ip_address})"
			end
		end

		unless server.port.nil?
			result << " (port #{server.port})"
		end

		return result
	end
end
