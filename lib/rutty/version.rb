module Rutty
  
  ##
  # The current version of the gem, expressed in Ruby code so it can
  # be accessed programmatically.
  #
  # @author Josh Lindsey
  # @see http://semver.org
  module Version
    MAJOR = 2
    MINOR = 3
    PATCH = 0
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end