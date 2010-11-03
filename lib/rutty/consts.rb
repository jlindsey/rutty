module Rutty
  module Consts
    GENERAL_CONF_FILE = 'defaults.yaml'
    NODES_CONF_FILE = 'nodes.yaml'
    
    CONF_DIR = File.join(ENV['HOME'], '.rutty')
    GENERAL_CONF = File.join(CONF_DIR, GENERAL_CONF_FILE)
    NODES_CONF = File.join(CONF_DIR, NODES_CONF_FILE)
  end
end
