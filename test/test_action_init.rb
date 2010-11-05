require 'helper'

class TestActionInit < Test::Unit::TestCase
  context "The `rutty init' action" do
    setup { clean_test_config! }
    teardown { clean_test_config! }
    
    should "create the file structure if it doesn't exist" do
      out = %x(#{RUTTY_BIN} init #{TEST_CONF_DIR})
      
      assert_file_exists TEST_CONF_DIR
      assert_file_exists TEST_GENERAL_CONF
      assert_file_exists TEST_NODES_CONF
    end
    
    should "report that the file structure already exists if it does" do
      ensure_fresh_config!
      
      out = %x(#{RUTTY_BIN} init #{TEST_CONF_DIR})
      
      assert_match /^\s+exists\s+#{TEST_CONF_DIR}$/, out
      assert_match /^\s+exists\s+#{TEST_GENERAL_CONF}$/, out
      assert_match /^\s+exists\s+#{TEST_NODES_CONF}$/, out
    end
    
    should "report that it has created the file structure if it doesn't exist" do
      out = %x(#{RUTTY_BIN} init #{TEST_CONF_DIR})
      
      assert_match /^\s+create\s+#{TEST_CONF_DIR}$/, out
      assert_match /^\s+create\s+#{TEST_GENERAL_CONF}$/, out
      assert_match /^\s+create\s+#{TEST_NODES_CONF}$/, out
    end
  end
end
