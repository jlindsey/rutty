require 'helper'
require 'ostruct'

class TestNodes < Test::Unit::TestCase
  context "The Rutty::Nodes class" do
    setup do
      ensure_fresh_config!
      seed_nodes
      
      @nodes = Rutty::Nodes.load_config TEST_CONF_DIR
    end
    
    teardown { clean_test_config! }
    
    should "return an instance of itself on #load_config" do
      assert_instance_of Rutty::Nodes, @nodes
    end
    
    should "load the nodes from the config file correctly" do
      assert_equal 1, @nodes.length
      
      node = @nodes.pop
      
      assert_equal ENV['USER'], node.user
      assert_equal 22, node.port
      assert_equal "#{ENV['HOME']}/.ssh/id_rsa", node.keypath
      assert_equal %w(localhost test), node.tags
    end
  end
  
  context "A Rutty::Nodes instance" do
    setup do 
      @node1 = Rutty::Node.new :host => 'localhost',
                               :port => 22,
                               :user => 'root',
                               :keypath => '/dev/null',
                               :tags => %w(localhost fake test)
      @node2 = Rutty::Node.new :host => 'google.com',
                               :port => 22,
                               :user => 'google',
                               :keypath => '/home/user/.ssh/id_rsa',
                               :tags => %w(google fake test)
      @node3 = Rutty::Node.new :host => 'example.com',
                               :port => 22333,
                               :user => 'example',
                               :keypath => '/home/example/.ssh/id_rsa.pem',
                               :tags => %w(broken test example)
      
      @nodes = Rutty::Nodes.new [@node1, @node2, @node3]
    end
    
    teardown { clean_test_config! }
    
    should "correctly instantiate when passed an array" do
      assert_contains @nodes, @node1, @node2
    end
    
    should "return the correct Proc type for each query string type" do
      Rutty::Nodes.publicize_methods do
        assert_instance_of Rutty::Procs::SingleTagQuery, @nodes.get_tag_query_filter('foo')
        assert_instance_of Rutty::Procs::MultipleTagQuery, @nodes.get_tag_query_filter('foo,bar')
        assert_instance_of Rutty::Procs::SqlLikeTagQuery, @nodes.get_tag_query_filter("'foo' AND 'bar' OR 'baz'")
      end
    end
    
    should "generate the correct Proc string to eval" do
      Rutty::Nodes.publicize_methods do
          require 'treetop'
          require 'rutty/treetop/syntax_nodes'
          require 'rutty/treetop/tag_query'

          parser = TagQueryGrammarParser.new

          proc_str = @nodes.recursive_build_query_proc_string parser.parse("'foo' AND 'bar' OR 'baz'").elements
          proc_str = proc_str.rstrip << ') }'
          
          assert_equal "Procs::SqlLikeTagQuery.new { |n| !(n.has_tag?('foo') && n.has_tag?('bar') || n.has_tag?('baz')) }", proc_str
          
          proc_str = @nodes.recursive_build_query_proc_string parser.parse("'test' OR ('example' AND 'foo')").elements
          proc_str = proc_str.rstrip << ') }'
          
          assert_equal "Procs::SqlLikeTagQuery.new { |n| !(n.has_tag?('test') || (n.has_tag?('example') && n.has_tag?('foo'))) }", proc_str
      end
    end
    
    should "raise an exception on malformed tag query strings" do
      Rutty::Nodes.publicize_methods do
        ["'foo' ARND 'bar'", "'fail", "'failure' AND )'foo'"].each do |str|
          assert_raises Rutty::InvalidTagQueryString do
            @nodes.get_tag_query_filter str
          end
        end
      end
    end
    
    should "filter out nodes matching provided criteria" do
      assert_equal [@node1, @node2], @nodes.filter(OpenStruct.new :port => 22)
      assert_equal [@node2], @nodes.filter(OpenStruct.new :user => 'google')
      assert_equal [@node2], @nodes.filter(OpenStruct.new :keypath => '/home/user/.ssh/id_rsa')
    end
    
    should "correctly filter on a single tag and return the correct node(s)" do
      filtered = @nodes.filter(OpenStruct.new :tags => 'test')
      assert_equal 3, filtered.length
      assert_equal [@node1, @node2, @node3], filtered
      
      filtered = @nodes.filter(OpenStruct.new :tags => 'fake')
      assert_equal 2, filtered.length
      assert_equal [@node1, @node2], filtered
      
      filtered = @nodes.filter(OpenStruct.new :tags => 'google')
      assert_equal 1, filtered.length
      assert_equal [@node2], filtered
    end
    
    should "correctly filter on a comma-separated list of tags and return the correct node(s)" do
      filtered = @nodes.filter(OpenStruct.new :tags => 'broken,example')
      assert_equal 1, filtered.length
      assert_equal [@node3], filtered
      
      filtered = @nodes.filter(OpenStruct.new :tags => 'test,fake')
      assert_equal 3, filtered.length
      assert_equal [@node1, @node2, @node3], filtered
      
      filtered = @nodes.filter(OpenStruct.new :tags => 'localhost,example')
      assert_equal 2, filtered.length
      assert_equal [@node1, @node3], filtered
    end
    
    should "correctly filter on a SQL-like tag query and return the correct node(s)" do
      filtered = @nodes.filter(OpenStruct.new :tags => "'test' AND 'localhost'")
      assert_equal 1, filtered.length
      assert_equal [@node1], filtered
      
      filtered = @nodes.filter(OpenStruct.new :tags => "'example' OR 'localhost'")
      assert_equal 2, filtered.length
      assert_equal [@node1, @node3], filtered
      
      filtered = @nodes.filter(OpenStruct.new :tags => "'localhost' AND 'test' OR ('google')")
      assert_equal 2, filtered.length
      assert_equal [@node1, @node2], filtered
    end
    
    should "correctly write out a node config" do
      ensure_fresh_config!
      
      @nodes.write_config TEST_CONF_DIR
      new_nodes = Rutty::Nodes.load_config TEST_CONF_DIR
      
      assert_contains new_nodes, @node1, @node2
    end
  end
end
