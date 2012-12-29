require 'fileutils'

namespace :api do
	namespace :test do
		desc "Run all spec files"
	    task :all do |t|
	      ENV['RACK_ENV'] = "test"
	      
	      sh %{ ruby -S rspec --color --format nested --backtrace }
	    end

	    desc "Run just the spec files indicated in the files environment variable"
	    task :some do |t|
	      unless ENV.include?("files")
	        raise "usage: #{$0} #{t.name} files=SPEC_FILES"
	      end

	      files = ENV['files']

	      ENV['RACK_ENV'] = "test"
	      sh %{ ruby -S rspec --color --format nested --backtrace #{files} }
	    end
	    
	    desc "Run just the spec files for one version of the API"
	    task :version do |t|
	      unless ENV.include?("version")
	        raise "usage: #{$0} #{t.name} version=API_VERSION_NUMBER"
	      end
	      
	      files = Dir.glob(File.join(File.dirname(__FILE__), "../../spec/api/v#{ENV['version']}/**/*.rb"))
	      
	      files.reject! {|file| file.ends_with?("spec_helper.rb")}
	      
	      ENV['RACK_ENV'] = "test"
	      sh %{ ruby -S rspec --color --format nested --backtrace #{files.join(" ")} }
	    end
	end
end