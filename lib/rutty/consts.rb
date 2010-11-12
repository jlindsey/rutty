module Rutty
  ##
  # Simple container module for constants.
  #
  # @author Josh Lindsey
  # @since 2.0.0
  module Consts
    ## List of possible output formats
    OUTPUT_FORMATS = %w(human-readable json xml)
    ## Default output format
    DEFAULT_OUTPUT_FORMAT = 'human-readable'
    
    ## Name of the general (defaults) config file
    GENERAL_CONF_FILE = 'defaults.yaml'
    ## Name of the datastore file for user-defined nodes
    NODES_CONF_FILE = 'nodes.yaml'
    
    ## Default configuaration storage directory
    CONF_DIR = File.join(ENV['HOME'], '.rutty')
    ## Default general (defaults) config file location
    GENERAL_CONF = File.join(CONF_DIR, GENERAL_CONF_FILE)
    ## Default nodes datastore file location
    NODES_CONF = File.join(CONF_DIR, NODES_CONF_FILE)
  end
end
