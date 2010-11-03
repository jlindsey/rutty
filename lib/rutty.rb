require 'rubygems'
require 'rutty/actions'
require 'rutty/config'
require 'rutty/consts'
require 'rutty/errors'
require 'rutty/helpers'
require 'rutty/node'
require 'rutty/nodes'

module Rutty
  class Runner
    attr_writer :config_dir
  
    include Rutty::Consts
    include Rutty::Helpers
    include Rutty::Actions
  
    def initialize config_dir = nil
      self.config_dir = config_dir
    end
  
    def config
      @config ||= Rutty::Config.load_config self.config_dir
    end
  
    def nodes
      @nodes ||= Rutty::Nodes.load_config self.config_dir
    end
    
    def config_dir
      (@config_dir.nil? && Rutty::Consts::CONF_DIR) || @config_dir
    end
  end
end
