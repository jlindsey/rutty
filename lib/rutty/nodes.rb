require 'rutty/node'
require 'rutty/consts'

module Rutty
  class Nodes < Array
    class << self
      def load_config file
        require 'yaml'
        Rutty::Nodes.new YAML.load(File.open(file).read)
      end
    end
    
    def filter opts = {}
      return self if opts[:all]
      
      ary = Array.new self
      
      ary.reject! { |n| n.keypath == opts[:keypath] } unless opts[:keypath].nil?
      ary.reject! { |n| n.user == opts[:user] } unless opts[:user].nil?
      ary.reject! { |n| n.port == opts[:port] } unless opts[:port].nil?
      ary.reject! { |n| !(n.tags & opts[:tags]).empty? } unless opts[:tags].nil?
      
      ary
    end
    
    def write_config
      File.open(Rutty::Consts::NODES_CONF, 'w') do |f|
        YAML.dump(self, f)
      end
    end
  end
end