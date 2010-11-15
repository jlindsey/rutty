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
