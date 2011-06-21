require 'rutty/config'

module Rutty
  
  ##
  # A wrapper class representing an individual node. Normally contained by {Rutty::Nodes}.
  #
  # @see Rutty::Config
  # @author Josh Lindsey
  # @since 2.0.0
  class Node < Config
    class << self
      ##
      # Override the inherited {Rutty::Config.load_config} method, raising an exception
      # to indicate improper usage.
      # 
      # @since 2.3.3
      # @raise [RuntimeError] On call, as this class has no use for this method
      def load_config dir
        raise "Unable to call load_config on Node objects."
      end
    end

    ##
    # Initialize a new {Rutty::Node} instance by merging the user-provided data with
    # the configured defaults.
    #
    # @see Rutty::Config#initialize
    # @param [Hash] data The data provided by the user
    # @param [Hash] defaults The defaults data provided by the {Rutty::Config} class
    def initialize data, defaults = {}
      merged_data = defaults.merge data
      super merged_data
    end
    
    ##
    # Whether this object's tags array includes the specified tag.
    #
    # @param [String] tag The tag string to check for
    def has_tag? tag
      return false if self.tags.nil? 
      self.tags.include? tag
    end
    
    ##
    # Relation of this {Rutty::Node} to another {Rutty::Node}. Used for sorting.
    # Compares the host property of the nodes, as it's the only property guaranteed to be
    # set and unique.
    #
    # @see http://ruby-doc.org/core/classes/String.html#M000763
    # @param [Rutty::Node] other The other {Rutty::Node} to compare to
    # @return [Integer] Relation of self to other: -1 for less-than, 0 for equal-to, 1 for greater-than
    def <=> other
      self.host <=> other.host
    end
    
    ##
    # Checks for object eqality. Checks each property of this {Node} against the other.
    #
    # @param (see Rutty::Node#<=>)
    # @return [Boolean]
    def == other
      self.host == other.host and
      self.port == other.port and
      self.user == other.user and
      self.keypath == other.keypath and
      self.tags == other.tags
    end
  end
end
