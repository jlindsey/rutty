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

    ##
    # Returns a string formatted to a more human-readable representation of a time difference in seconds.
    #
    # @since 2.4.0
    #
    # @param [Float] seconds_total The number of seconds to convert
    # @return [String] The formatted string
    def seconds_in_words seconds_total
      hours = seconds_total / 3600
      minutes = (seconds_total - (3600 * hours)) / 60
      seconds = (seconds_total % (hours >= 1 ? (3600 * hours) : 60)) % 60
      
      out = ''
      
      unless hours < 1
        out << hours.to_s
        out << ((hours > 1) ? " hours " : " hour ")
      end

      unless minutes < 1
        out << minutes.to_s
        out << ((minutes > 1) ? " minutes " : " minute ")
      end
      
      out << seconds.to_s
      out << ((seconds > 1) ? " seconds" : " second")
      
      out.strip
    end
  end
end
