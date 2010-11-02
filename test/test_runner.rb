require 'helper'

class TestRunner < Test::Unit::TestCase
  context "A Runner instance" do
    setup { 
      @r = Rutty::Runner.new 
      call_init
    }
    
    should "respond to config" do
      assert_respond_to @r, :config
    end
    
    should "respond to nodes" do
      assert_respond_to @r, :nodes
    end
    
    should "return the correct object type for #config" do
      assert_instance_of Rutty::Config, @r.config
    end
    
    should "return the correct object type for #nodes" do
      assert_instance_of Rutty::Nodes, @r.nodes
    end
  end
end
