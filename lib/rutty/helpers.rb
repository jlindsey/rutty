require 'rutty/errors'
require 'rutty/version'

module Rutty
  module Helpers
    def check_installed!
      unless File.exists? self.config_dir
        raise Rutty::NotInstalledError.new %Q(Can't find conf directory at #{self.config_dir}.
         Run `rutty init' first. (Or rutty --help for usage))
      end
    end
    
    def self.get_version
      Rutty::Version::STRING
    end
  end
end
