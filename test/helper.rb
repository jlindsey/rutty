require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rutty'

class Test::Unit::TestCase
  TEST_CONF_DIR = File.join(File.dirname(__FILE__), '..', 'tmp')
  TEST_GENERAL_CONF = File.join(TEST_CONF_DIR, 'defaults.yaml')
  TEST_NODES_CONF = File.join(TEST_CONF_DIR, 'nodes.yaml')
  
  RUTTY_BIN = File.join File.dirname(__FILE__), '..', 'bin', 'rutty'
  
  def call_init
    unless File.exists? TEST_CONF_DIR
      %x(#{RUTTY_BIN} init #{TEST_CONF_DIR})
    end
  end
  
  def clean_test_config
    %x(rm -rf #{TEST_CONF_DIR}) if File.exists? TEST_CONF_DIR
  end
  
  def seed_nodes
    %x(#{RUTTY_BIN} add_node localhost -c #{TEST_CONF_DIR} -k ~/.ssh/id_rsa.pem -u root --tags localhost,test -p 22)
  end
  
  def ensure_fresh_config!
    clean_test_config
    call_init
  end
end
