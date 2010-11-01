require 'rutty/errors'
require 'rutty/consts'

module Rutty
  module Helpers
    def check_installed!
      unless File.exists? CONF_DIR
        raise Rutty::NotInstalledError.new %Q(Can't find conf directory at #{CONF_DIR}.
         Run `rutty init' first. (Or rutty --help for usage))
      end
    end
    
    def get_version
      File.open('../../VERSION', 'r').read.chomp
    end
  end
end
