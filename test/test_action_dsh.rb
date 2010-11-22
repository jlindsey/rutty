require 'helper'

class TestActionDSH < Test::Unit::TestCase
  context "The `rutty dsh' action" do
    setup { ensure_fresh_config! }
    teardown { clean_test_config! }
    
    should "report no defined nodes when no nodes defined" do
      output = %x(#{RUTTY_BIN} -c #{TEST_CONF_DIR} -a uptime)
      
      yellow = '\\e\[33m'
      clear = '\\e\[0m'
      
      assert_match /^#{yellow}No nodes defined#{clear}$/, output.rstrip
    end
    
    should "display a critical error state when unable to connect" do
      seed_bad_node
      
      output = %x(#{RUTTY_BIN} -c #{TEST_CONF_DIR} -a uptime)
      
      red_bg = '\\e\[41m'
      yellow = '\\e\[33m'
      red = '\\e\[31m'
      clear = '\\e\[0m'
      
      assert_match /^#{yellow}#{red_bg}example\.com#{clear}\s+#{red}ERROR: Connection timeout#{clear}$/, output.rstrip
    end
    
    should "display a general error state when an exit code > 0 is returned" do
      seed_nodes
      
      output = %x(#{RUTTY_BIN} -c #{TEST_CONF_DIR} -a foobar)
      
      bold = '\\e\[1m'
      red = '\\e\[31m'
      clear = '\\e\[0m'
      
      assert_match /^#{bold}#{red}localhost#{clear}\s+.*command not found.*$/, output.rstrip
    end
    
    should "display the proper output on success" do
      seed_nodes
      
      output = %x(#{RUTTY_BIN} -c #{TEST_CONF_DIR} -a whoami)
      
      green = '\\e\[32m'
      clear = '\\e\[0m'
      
      assert_match /^#{green}localhost#{clear}\s+#{ENV['USER']}$/, output.rstrip
    end
  end
end
