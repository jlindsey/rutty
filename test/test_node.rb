require 'helper'

class TestNode < Test::Unit::TestCase
  context "A Rutty::Node instance" do
    setup do 
      hash = { :foo => "blah", :test => "hello" }
      @defaults = { :foo => "bar", :baz => "widget" }
      @node = Rutty::Node.new hash, @defaults
    end
    
    should "respond to its methods" do
      node = Rutty::Node.new Hash.new, @defaults
      
      assert_respond_to node, :has_tag?
      assert_respond_to node, :<=>
    end
    
    should "properly merge data on initialization" do
      hash = { :foo => "blah", :test => "hello", :baz => "widget" }
      assert_equal hash, @node.to_hash
    end
    
    should "report whether it has a tag" do
      @node.tags = %w(foo bar baz)
      assert @node.has_tag?('foo')
      assert !@node.has_tag?('widget')
    end
    
    should "properly determine its sorting order relative to other Nodes" do
      hash1 = { :host => 'google.com' }
      hash2 = { :host => 'yahoo.com' }
      node1 = Rutty::Node.new hash1, @defaults
      node2 = Rutty::Node.new hash2, @defaults
      
      assert_equal node1 <=> node2, -1
    end
  end
end
