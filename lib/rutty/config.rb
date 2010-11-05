module Rutty
  
  ##
  # Flexible config class able to use both hash accessors and object accessors. Nested
  # attributes are also instances of this class, allowing for object (dot) style accessor
  # chaining.
  #
  # @see http://mjijackson.com/2010/02/flexible-ruby-config-objects
  # 
  # @example
  #   config = Config.new :foo => "bar", :test => "baz", :widget => { :another => "string" }
  #
  #   config.foo            # => "bar"
  #   config.widget.another # => "string"
  #
  # @author Michael Jackson
  # @author Josh Lindsey
  # @since 2.0.0
  class Config
    class << self
      ##
      # Loads the default config data from the yaml file in the specified config dir.
      #
      # @see Rutty::Consts::GENERAL_CONF_FILE
      # @param [String] dir The directory to look in for the file specified by {Rutty::Consts::GENERAL_CONF_FILE}
      # @return [Rutty::Config] The populated {Config} instance
      def load_config dir
        require 'yaml'
        
        data = YAML.load(File.open(File.join(dir, Rutty::Consts::GENERAL_CONF_FILE)).read)
        Rutty::Config.new data
      end
    end
    
    ##
    # Returns a new {Config} populated with the specified data hash.
    #
    # @see #update!
    # @param (see #update!)
    def initialize(data={})
      @data = {}
      update!(data)
    end

    ##
    # Updates this instance's @data attribute with the specified data hash.
    #
    # @param [Hash] data Data hash to iterate over
    # @see #[]=
    def update!(data)
      data.each do |key, value|
        self[key] = value
      end
    end

    ##
    # Retrieve the specified key via Hash accessor syntax.
    #
    # @param [Symbol, String] key The key to lookup
    # @return [Object] The object corresponding to the key
    def [](key)
      @data[key.to_sym]
    end

    ##
    # Set the specified key as the specified value via Hash accessor syntax.
    #
    # @param [Symbol, String] key The key to set
    # @param [Object] value The value to set into the key
    def []=(key, value)
      if value.class == Hash
        @data[key.to_sym] = Config.new(value)
      else
        @data[key.to_sym] = value
      end
    end

    ##
    # Simply returns this instance's @data attribute, which is internally stored as a hash.
    # 
    # @return [Hash] The @data attribute
    def to_hash
      @data
    end
    
    ##
    # Allows for object accessor (dot) syntax to access the stored data.
    # If the missing method ends with an equals, calls {#[]=}, otherwise calls {#[]}
    #
    # @param [Symbol] sym The method symbol
    # @param [*Array] args The splatted array of method arguments
    def method_missing(sym, *args)
      if sym.to_s =~ /(.+)=$/
        self[$1] = args.first
      else
        self[sym]
      end
    end
  end
end