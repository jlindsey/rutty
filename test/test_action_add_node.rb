require 'helper'

class TestActionAddNode < Test::Unit::TestCase
  context "The `rutty add_node' action" do
    setup { ensure_fresh_config! }
    teardown { clean_test_config! }
    
    should "properly create a new node entry when called" do
      require 'yaml'
      
      %x(#{RUTTY_BIN} add_node -c #{TEST_CONF_DIR} example.com -k /home/user/.ssh/id_rsa -u root -p 22333 --tags example,testing)
      
      nodes = YAML.load(File.open(TEST_NODES_CONF).read)
      
      assert_equal 1, nodes.length
      
      node = nodes.pop
      assert_equal 'example.com', node.host
      assert_equal '/home/user/.ssh/id_rsa', node.keypath
      assert_equal 22333, node.port
      assert_equal 'root', node.user
      assert_equal %w(example testing), node.tags
    end
  end
end