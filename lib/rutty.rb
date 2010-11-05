require 'rubygems'
require 'rutty/actions'
require 'rutty/config'
require 'rutty/consts'
require 'rutty/errors'
require 'rutty/helpers'
require 'rutty/node'
require 'rutty/nodes'

##
# The RuTTY top-level module. Everything in the RuTTY gem is contained in this module.
#
# @author Josh Lindsey
# @since 2.0.0
module Rutty
  
  ##
  # The Rutty::Runner class includes mixins from the other modules. All end-user interaction
  # should be done through this class.
  #
  # @author Josh Lindsey
  # @since 2.0.0 
  class Runner
    attr_writer :config_dir
  
    include Rutty::Consts
    include Rutty::Helpers
    include Rutty::Actions
  
    ##
    # Initialize a new {Rutty::Runner} instance
    #
    # @param config_dir [String] Optional parameter specifying the directory RuTTY has been init'd into
    def initialize config_dir = nil
      self.config_dir = config_dir
    end
  
    ##
    # Lazy-load the {Rutty::Config} object for this instance, based on the config_dir param
    # passed to {#initialize}.
    #
    # @return [Rutty::Config]
    def config
      @config ||= Rutty::Config.load_config self.config_dir
    end
  
    ##
    # Lazy-load the {Rutty::Nodes} object containing the user-defined nodes' connection info.
    # Loads from the config_dir param passed to {#initialize}
    #
    # @return [Rutty::Nodes]
    def nodes
      @nodes ||= Rutty::Nodes.load_config self.config_dir
    end
    
    ##
    # If @config_dir is nil, returns {Rutty::Consts::CONF_DIR}. Otherwise return @config_dir.
    #
    # @see Rutty::Consts::CONF_DIR
    # @return [String] The user-specified config directory, falling back to the default on nil
    def config_dir
      (@config_dir.nil? && Rutty::Consts::CONF_DIR) || @config_dir
    end
  end
end
