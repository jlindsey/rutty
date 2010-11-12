require 'helper'

class TestActionListNodes < Test::Unit::TestCase
  context "The `rutty list_nodes' action" do
    setup { ensure_fresh_config! }
    teardown { clean_test_config! }
    
    should "report no defined nodes when no nodes are defined" do
      output = %x(#{RUTTY_BIN} list_nodes -c #{TEST_CONF_DIR} 2>&1)
      
      yellow = '\\e\[33m'
      clear = '\\e\[0m'
      
      assert_match /#{yellow}No nodes defined#{clear}/, output
    end
    
    should "properly list defined nodes in ASCII table format" do
      3.times { seed_nodes }
      output = %x(#{RUTTY_BIN} list_nodes -c #{TEST_CONF_DIR} 2>&1)
      output = output.split("\n")
      
      separator = /^(?:\+{1}\-+)+\+$/
      
      assert_match separator, output.shift
      assert_match /^\|\sHost\s+\|\sKey\s+\|\sUser\s+\|\sPort\s+\|\sTags\s+\|$/, output.shift
      assert_match separator, output.shift
      
      3.times do
        assert_match /^\|\slocalhost\s+\|\s#{ENV['HOME']}\/\.ssh\/id_rsa\.pem\s+\|\sroot\s+\|\s22\s+\|\slocalhost,\stest\s+\|$/o, output.shift
      end
      
      assert_match separator, output.shift
    end
  end
end
