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
    attr_accessor :config
    attr_accessor :nodes
  
    include Rutty::Consts
    include Rutty::Helpers
    include Rutty::Actions
  
    def config
      @config ||= Rutty::Config.load_config
    end
  
    def nodes
      @nodes ||= Rutty::Nodes.load_config
    end
  end
end