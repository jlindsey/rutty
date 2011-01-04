require 'helper'

class TestConsts < Test::Unit::TestCase
  context "The Rutty::Consts module" do
    should "have all the constants set" do
      assert_not_nil Rutty::Consts::GENERAL_CONF_FILE
      assert_not_nil Rutty::Consts::NODES_CONF_FILE
      assert_not_nil Rutty::Consts::CONF_DIR
      assert_not_nil Rutty::Consts::GENERAL_CONF
      assert_not_nil Rutty::Consts::NODES_CONF
    end
  end
end
