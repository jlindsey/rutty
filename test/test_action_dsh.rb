require 'helper'

class TestActionDSH < Test::Unit::TestCase
  context "The `rutty dsh' action" do
    setup { ensure_fresh_config! }
    teardown { clean_test_config! }
    
    should "report no defined nodes when no nodes defined" do
      output = %x(#{RUTTY_BIN} -c #{TEST_CONF_DIR} -a uptime)
      
      assert_match /^#{Colors::YELLOW}No nodes defined#{Colors::CLEAR}$/, output.rstrip
    end
    
    should "display a critical error state when unable to connect" do
      seed_bad_node
      
      output = %x(#{RUTTY_BIN} -c #{TEST_CONF_DIR} -a uptime)
      
      assert_match /^#{Colors::YELLOW}#{Colors::RED_BG}example\.com#{Colors::CLEAR}\s+#{Colors::RED}ERROR: Connection timeout#{Colors::CLEAR}$/, output.rstrip
    end
    
    should "display a general error state when an exit code > 0 is returned" do
      seed_nodes
      
      output = %x(#{RUTTY_BIN} -c #{TEST_CONF_DIR} -a foobar)

      assert_match /^#{Colors::BOLD}#{Colors::RED}localhost#{Colors::CLEAR}\s+.*command not found.*$/, output.rstrip
    end
    
    should "display the proper output on success" do
      seed_nodes
      
      output = %x(#{RUTTY_BIN} -c #{TEST_CONF_DIR} -a whoami)
      
      assert_match /^#{Colors::GREEN}localhost#{Colors::CLEAR}\s+#{ENV['USER']}$/, output.rstrip
    end
    
    should "display successful statistics output" do
      seed_nodes
      
      output = %x(#{RUTTY_BIN} -c #{TEST_CONF_DIR} -a whoami)
      
      assert_match /\n+#{Colors::GREEN}1 host\(s\), 0 error\(s\), \d+(?:\.\d+)? seconds?#{Colors::CLEAR}/, output
    end
    
    should "display error-state statistics output" do
      seed_bad_node
      
      output = %x(#{RUTTY_BIN} -c #{TEST_CONF_DIR} -a whoami)
      
      assert_match /\n+#{Colors::RED}1 host\(s\), 1 error\(s\), \d+(?:\.\d+)? seconds?#{Colors::CLEAR}/, output
    end
  end
end
