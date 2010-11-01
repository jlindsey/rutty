require 'rutty/errors'
require 'rutty/consts'
require 'rutty/version'

module Rutty
  module Helpers
    def check_installed!
      unless File.exists? Rutty::Consts::CONF_DIR
        raise Rutty::NotInstalledError.new %Q(Can't find conf directory at #{Rutty::Consts::CONF_DIR}.
         Run `rutty init' first. (Or rutty --help for usage))
      end
    end
    
    def get_version
      Rutty::Version::STRING
    end
  end
end
