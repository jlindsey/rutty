module Rutty
  ##
  # Raised by {Rutty::Helpers#check_installed!} if the check fails.
  #
  # @author Josh Lindsey
  # @since 2.0.0
  class NotInstalledError < StandardError; end
  
  ##
  # Raised by various {Rutty::Actions} methods on invalid options, etc.
  #
  # @author Josh Lindsey
  # @since 2.0.0
  class BadUsage < StandardError; end
  
  ##
  # Raised by {Rutty::Runner} if a bad output format is passed.
  #
  # @author Josh Lindsey
  # @since 2.1.4
  class InvalidOutputFormat < StandardError; end
end