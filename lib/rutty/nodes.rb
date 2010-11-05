require 'rutty/node'
require 'rutty/consts'

module Rutty
  
  ##
  # Simple wrapper class for {Rutty::Node} instances. Contains methods to load node data from file,
  # write data back to the file, and filter nodes based on user-supplied criteria.
  #
  # @author Josh Lindsey
  # @since 2.1.0
  class Nodes < Array
    class << self
      ##
      # Loads the config data from the yaml file contained in the specified dir.
      #
      # @param [String] dir The directory to look in for the filename specified by {Rutty::Consts::NODES_CONF_FILE}
      # @return [Rutty::Nodes] The filled instance of {Rutty::Node} objects
      # @see Rutty::Consts::NODES_CONF_FILE
      def load_config dir
        require 'yaml'
        Rutty::Nodes.new YAML.load(File.open(File.join(dir, Rutty::Consts::NODES_CONF_FILE)).read)
      end
    end
    
    ##
    # Filters out the {Rutty::Node} objects contained in this instance based on user-defined criteria.
    #
    # @param [Hash, #[]] opts The filter criteria
    # @option opts [String] :keypath (nil) The path to the private key
    # @option opts [String] :user (nil) The user to login as
    # @option opts [Integer] :port (nil) The port to connect to
    # @option opts [Array<String>] :tags (nil) The tags to filter by
    # @return [Array] An Array containing the {Rutty::Node} objects after filtering
    def filter opts = {}
      return self if opts[:all]
      
      ary = Array.new self
      
      ary.reject! { |n| n.keypath != opts[:keypath] } unless opts[:keypath].nil?
      ary.reject! { |n| n.user != opts[:user] } unless opts[:user].nil?
      ary.reject! { |n| n.port != opts[:port] } unless opts[:port].nil?
      ary.reject! { |n| (n.tags & opts[:tags]).empty? } unless opts[:tags].nil?
      
      ary
    end
    
    ##
    # Writes the updated nodes config back into the nodes.yaml file in the specified dir.
    #
    # @param (see Rutty::Nodes.load_config)
    # @see (see Rutty::Nodes.load_config)
    def write_config dir
      File.open(File.join(dir, Rutty::Consts::NODES_CONF_FILE), 'w') do |f|
        YAML.dump(self, f)
      end
    end
  end
end