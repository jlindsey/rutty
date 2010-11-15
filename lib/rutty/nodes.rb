require 'rutty/node'
require 'rutty/consts'

module Rutty

  ##
  # Simple container class for {Rutty::Node} instances. Contains methods to load node data from file,
  # write data back to the file, and filter nodes based on user-supplied criteria.
  #
  # @author Josh Lindsey
  # @since 2.1.0
  class Nodes < Array
    class << self
      ##
      # Loads the users's node data from the yaml file contained in the specified dir.
      #
      # @param [String] dir The directory to look in for the filename specified by {Rutty::Consts::NODES_CONF_FILE}
      # @return [Rutty::Nodes] The filled instance of {Rutty::Node} objects
      # @see Rutty::Consts::NODES_CONF_FILE
      def load_config dir
        require 'yaml'
        Rutty::Nodes.new YAML.load(File.open(File.join(dir, Rutty::Consts::NODES_CONF_FILE)).read)
      end
    end

    ##
    # Filters out the {Rutty::Node} objects contained in this instance based on user-defined criteria.
    #
    # @param [Hash, #[]] opts The filter criteria
    # @option opts [String] :keypath (nil) The path to the private key
    # @option opts [String] :user (nil) The user to login as
    # @option opts [Integer] :port (nil) The port to connect to
    # @option opts [String] :tags (nil) The tags to filter by
    # @return [Rutty::Nodes] A duplicate of this object, but containing the {Rutty::Node} objects after filtering.
    def filter opts = {}
      return self if opts.all

      ary = self.dup

      ary.delete_if { |n| n.keypath != opts.keypath } unless opts.keypath.nil?
      ary.delete_if { |n| n.user != opts.user } unless opts.user.nil?
      ary.delete_if { |n| n.port != opts.port } unless opts.port.nil?
      ary.delete_if &get_tag_query_filter(opts.tags) unless opts.tags.nil? 
      
      ary
    end
    
    ##
    # Same as {#filter}, but destructive on this object instead of a duplicate.
    #
    # @param (see #filter)
    # @option (see #filter)
    # @return [Rutty::Nodes] This object with the requested nodes filtered out.
    def filter! opts = {}
      return self if opts.all

      self.delete_if { |n| n.keypath != opts.keypath } unless opts.keypath.nil?
      self.delete_if { |n| n.user != opts.user } unless opts.user.nil?
      self.delete_if { |n| n.port != opts.port } unless opts.port.nil?
      self.delete_if &get_tag_query_filter(opts.tags) unless opts.tags.nil?
      
      self
    end

    ##
    # Writes the updated nodes config back into the nodes.yaml file in the specified dir.
    #
    # @param (see Rutty::Nodes.load_config)
    # @see (see Rutty::Nodes.load_config)
    def write_config dir
      File.open(File.join(dir, Rutty::Consts::NODES_CONF_FILE), 'w') do |f|
        YAML.dump(self, f)
      end
    end

    private

    ##
    # Builds and returns a <tt>Proc</tt> for {#filter}. The Proc
    # should be passed a {Rutty::Node} object when called. The Proc calls
    # {Rutty::Node#has_tag?} on the passed in object to determine tag inclusion.
    #
    # In other words, the Proc returned by this should be suitable for passing to 
    # Array#reject!, as that's what {#filter} calls.
    #
    # @param [String] query_str The string passed in by the user via the <tt>--tags</tt> option
    # @return [Proc] The generated filter Proc
    #
    # @see #recursive_build_query_proc_string
    # @see Rutty::Nodes#filter
    # @since 2.3.0
    def get_tag_query_filter query_str
      require 'rutty/proc_classes'

      filter = nil

      if query_str =~ /^[A-Za-z_-]+$/
        # Single tag query, no need to fire up the parser
        filter = Procs::SingleTagQuery.new { |n| !n.has_tag? query_str }
      elsif query_str =~ /^(?:[A-Za-z_-]+,?)+$/
        # Old-style comma-separated tag query. Still no
        # need to fire up the parser, just additively compare.
        tags = query_str.split(',')
        filter = Procs::MultipleTagQuery.new { |n| (n.tags & tags).empty? }
      else
        # New sql-like tag query. Need the parser for this.
        require 'treetop'
        require 'rutty/treetop/syntax_nodes'
        require 'rutty/treetop/tag_query'
               
        parser = TagQueryGrammarParser.new

        parsed_syntax_tree = parser.parse(query_str)

        raise InvalidTagQueryString.new "error: Unable to parse tag query string" if parsed_syntax_tree.nil?
        
        proc_str = recursive_build_query_proc_string parsed_syntax_tree.elements
        proc_str = proc_str.rstrip << ') }'

        filter = eval(proc_str)
      end

      filter
    end


    ##
    # Builds a string to be <tt>eval</tt>'d into a Proc by {#get_tag_query_filter}. Recursively
    # walks a Treetop parsed syntax tree, building the string as it goes. The string is not actually
    # evaluated into a Proc object in this method; that happens in {#get_tag_query_filter}.
    #
    # @param [Array<Treetop::Runtime::SyntaxNode>] elems A multidimensional array ultimately 
    #   consisting of Treetop SyntaxNodes or children thereof.
    # @param [String] str The string to build on. Passed around over recursions.
    # @return [String] The completed string to evaluate into a Proc.
    #
    # @see #get_tag_query_filter
    # @since 2.3.0
    def recursive_build_query_proc_string elems, str = ''
      return str if elems.nil? or elems.empty?

      str = 'Procs::SqlLikeTagQuery.new { |n| !(' if str.empty?

      elem = elems.shift

      case elem.class.to_s
      when 'TagQueryGrammar::Tag'
        str << "n.has_tag?(#{elem.text_value}) "
      when 'TagQueryGrammar::AndLiteral'
        str << "&& "
      when 'TagQueryGrammar::OrLiteral'
        str << "|| "
      when 'TagQueryGrammar::GroupStart'
        str << '('
      when 'TagQueryGrammar::GroupEnd'
        str.rstrip!
        str << ')'
      when 'TagQueryGrammar::QueryGroup'
        str = recursive_build_query_proc_string elem.elements, str
        # For some reason, Treetop won't let me assign a class to the "query" rule,
        # so it defaults to this class. This should be the only parsed rule that evaluates
        # to this generic class.
      when 'Treetop::Runtime::SyntaxNode'
        str = recursive_build_query_proc_string elem.elements, str
      end

      recursive_build_query_proc_string elems, str
    end
  end
end