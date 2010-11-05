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
end