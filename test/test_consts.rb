require 'helper'

class TestConsts < Test::Unit::TestCase
  context "The Rutty::Consts module" do
    should "have all the constants set" do
      assert_not_nil Rutty::Consts::CONF_DIR
      assert_not_nil Rutty::Consts::GENERAL_CONF
      assert_not_nil Rutty::Consts::NODES_CONF
    end
    
    should "have the constants be the proper values" do
      assert_equal Rutty::Consts::GENERAL_CONF_FILE, 'defaults.yaml'
      assert_equal Rutty::Consts::NODES_CONF_FILE, 'nodes.yaml'
      
      assert_equal Rutty::Consts::CONF_DIR, File.join(ENV['HOME'], '.rutty')
      assert_equal Rutty::Consts::GENERAL_CONF, File.join(Rutty::Consts::CONF_DIR, 'defaults.yaml')
      assert_equal Rutty::Consts::NODES_CONF, File.join(Rutty::Consts::CONF_DIR, 'nodes.yaml')
    end
  end
end
