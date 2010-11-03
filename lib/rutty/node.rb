require 'rutty/config'
require 'rutty/consts'

module Rutty
  class Node < Config    
    def initialize data, defaults = {}
      merged_data = defaults.merge data
      super merged_data
    end
    
    def has_tag? tag
      self.tags.include? tag
    end
    
    def <=> other
      self.host <=> other.host
    end
    
    def == other
      self.host == other.host and
      self.port == other.port and
      self.user == other.user and
      self.keypath == other.keypath and
      self.tags == other.tags
    end
  end
end