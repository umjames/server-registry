require "rubygems"
require "rack"

module ServerRegistry
  module API
    class MountPoint
      def self.app
        app, options = ::Rack::Builder.parse_file File.join(File.dirname(__FILE__), "config.ru")

        return app
      end
    end
  end
end