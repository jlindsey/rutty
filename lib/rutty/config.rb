# http://mjijackson.com/2010/02/flexible-ruby-config-objects
module Rutty
  class Config
    class << self
      def load_config dir
        require 'yaml'
        
        data = YAML.load(File.open(File.join(dir, Rutty::Consts::GENERAL_CONF_FILE)).read)
        Rutty::Config.new data
      end
    end
    
    def initialize(data={})
      @data = {}
      update!(data)
    end

    def update!(data)
      data.each do |key, value|
        self[key] = value
      end
    end

    def [](key)
      @data[key.to_sym]
    end

    def []=(key, value)
      if value.class == Hash
        @data[key.to_sym] = Config.new(value)
      else
        @data[key.to_sym] = value
      end
    end

    def to_hash
      @data
    end
    
    def method_missing(sym, *args)
      if sym.to_s =~ /(.+)=$/
        self[$1] = args.first
      else
        self[sym]
      end
    end
  end
end