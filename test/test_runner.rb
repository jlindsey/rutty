require 'helper'

class TestRunner < Test::Unit::TestCase
  context "A Runner instance" do
    setup do
      ensure_fresh_config!
      @r = Rutty::Runner.new TEST_CONF_DIR
    end
    
    should "respond to its methods" do
      assert_respond_to @r, :config
      assert_respond_to @r, :nodes
      assert_respond_to @r, :config_dir
      assert_respond_to @r, :config_dir=
    end
    
    should "return the correct object type for #config" do
      assert_instance_of Rutty::Config, @r.config
    end
    
    should "return the correct object type for #nodes" do
      assert_instance_of Rutty::Nodes, @r.nodes
    end
    
    should "correctly initialize with a supplied configuration directory" do
      assert_equal @r.config_dir, TEST_CONF_DIR
    end
    
    should "correctly fall back to default configuration directory" do
      r = Rutty::Runner.new
      assert_equal r.config_dir, Rutty::Consts::CONF_DIR
    end
  end
end
