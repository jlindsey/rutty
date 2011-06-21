require 'rutty/actions'
require 'rutty/config'
require 'rutty/consts'
require 'rutty/errors'
require 'rutty/helpers'
require 'rutty/node'
require 'rutty/nodes'

module Rutty
  ##
  # The Rutty::Runner class includes mixins from the other modules. All end-user interaction
  # should be done through this class.
  #
  # @author Josh Lindsey
  # @since 2.0.0 
  class Runner
    attr_writer :config_dir
    attr :config
    attr :nodes
    attr :output_format

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
    # @return [Rutty::Config] The loaded and parsed config object
    def config
      @config ||= Rutty::Config.load_config self.config_dir
    end

    ##
    # Lazy-load the {Rutty::Nodes} object containing the user-defined nodes' connection info.
    # Loads from the config_dir param passed to {#initialize}
    #
    # @return [Rutty::Nodes] The Nodes loaded from the config
    def nodes
      @nodes ||= Rutty::Nodes.load_config self.config_dir
    end

    ##
    # The user-specified config directory, falling back to the default on nil.
    # Used by {Rutty::Nodes.load_config} and {Rutty::Config.load_config} to determine
    # where to look for config files.
    #
    # @see Rutty::Consts::CONF_DIR
    # @return [String] The user-specified config directory, falling back to the default on nil.
    def config_dir
      (@config_dir.nil? && Rutty::Consts::CONF_DIR) || @config_dir
    end

    ##
    # The tool's output format, passed by the user via the rutty bin's flag. 
    # Must be one of the elements of {Rutty::Consts::OUTPUT_FORMATS}.
    # Defaults to {Rutty::Consts::DEFAULT_OUTPUT_FORMAT}
    #
    # @see Rutty::Consts::OUTPUT_FORMATS
    # @see Rutty::Consts::DEFAULT_OUTPUT_FORMAT
    # @return [String] The configured output format
    def output_format
      (@output_format.nil? && Rutty::Consts::DEFAULT_OUTPUT_FORMAT) || @output_format
    end

    ##
    # Sets @output_format, or raises an exception if the value is not included in {Rutty::Consts::OUTPUT_FORMATS}.
    #
    # @see Rutty::Consts::OUTPUT_FORMATS
    # @raise [Rutty::InvalidOutputFormat] On a disallowed output format string
    def output_format= format
      raise Rutty::InvalidOutputFormat.new "Invalid output format: #{format}" unless Rutty::Consts::OUTPUT_FORMATS.include? format

      @output_format = format
    end
  end
end
