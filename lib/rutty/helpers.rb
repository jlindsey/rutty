require 'rutty/errors'
require 'rutty/version'

module Rutty
  
  ##
  # Simple mixin module for miscellaneous methods that don't fit in elsewhere.
  #
  # @author Josh Lindsey
  # @since 2.0.0
  module Helpers
    ##
    # Check to ensure the config dir exists. Method expects this module to be included in a
    # class or module where self.config_dir is meaningful, such as {Rutty::Runner}.
    #
    # @raise [Rutty::NotInstalledError] If file cannot be found
    def check_installed!
      unless File.exists? self.config_dir
        raise Rutty::NotInstalledError.new %Q(Can't find conf directory at #{self.config_dir}.
         Run `rutty init' first. (Or rutty --help for usage))
      end
    end
    
    ##
    # Returns the version string contained in {Rutty::Version::STRING}. Used by the rutty bin.
    #
    # @see (see Rutty::Version)
    # @return [String] The version string
    def self.get_version
      Rutty::Version::STRING
    end
  end
end
