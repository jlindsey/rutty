module Rutty
  module Constants
    CONF_DIR = File.join(ENV['HOME'], '.rutty')
    GENERAL_CONF = File.join(CONF_DIR, 'defaults.yaml')
    NODES_CONF = File.join(CONF_DIR, 'nodes.yaml')
  end
end
