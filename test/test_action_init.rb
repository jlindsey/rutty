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
      
      cyan = '\\e\[36m'
      clear = '\\e\[0m'
      exists = "#{cyan}exists#{clear}"
      
      assert_match /^\s+#{exists}\s+#{TEST_CONF_DIR}$/o, out
      assert_match /^\s+#{exists}\s+#{TEST_GENERAL_CONF}$/o, out
      assert_match /^\s+#{exists}\s+#{TEST_NODES_CONF}$/o, out
    end
    
    should "report that it has created the file structure if it doesn't exist" do
      out = %x(#{RUTTY_BIN} init #{TEST_CONF_DIR})
      
      green = '\\e\[32m'
      clear = '\\e\[0m'
      create = "#{green}create#{clear}"
      
      assert_match /^\s+#{create}\s+#{TEST_CONF_DIR}$/o, out
      assert_match /^\s+#{create}\s+#{TEST_GENERAL_CONF}$/o, out
      assert_match /^\s+#{create}\s+#{TEST_NODES_CONF}$/o, out
    end
  end
end
