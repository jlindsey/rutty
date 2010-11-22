require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rutty'

class Test::Unit::TestCase
  # Terminal escape sequences for colors
  module Colors
    CLEAR   = '\\e\[0m'
    
    RED     = '\\e\[31m'
    YELLOW  = '\\e\[33m'
    GREEN   = '\\e\[32m'
    CYAN    = '\\e\[36m'

    RED_BG  = '\\e\[41m'

    BOLD    = '\\e\[1m'
  end
  
  TMP_DIR = File.join(File.dirname(__FILE__), '..', 'tmp')
  TEST_CONF_DIR = File.join(TMP_DIR, 'config')
  TEST_GENERAL_CONF = File.join(TEST_CONF_DIR, 'defaults.yaml')
  TEST_NODES_CONF = File.join(TEST_CONF_DIR, 'nodes.yaml')
  
  RUTTY_BIN = File.join File.dirname(__FILE__), '..', 'bin', 'rutty'
  
  def call_init
    unless File.exists? TEST_CONF_DIR
      %x(#{RUTTY_BIN} init #{TEST_CONF_DIR})
    end
  end
  
  def clean_test_config!
    %x(rm -rf #{TMP_DIR}) if File.exists? TMP_DIR
  end
  
  def seed_nodes
    out = %x(#{RUTTY_BIN} add_node localhost -c #{TEST_CONF_DIR} -k ~/.ssh/id_rsa -u #{ENV['USER']} -g localhost,test -p 22)
    assert_match /Added localhost/, out
  end
  
  def seed_bad_node
    out = %x(#{RUTTY_BIN} add_node example.com -c #{TEST_CONF_DIR} -g example,test,broken)
    assert_match /Added example\.com/, out
  end
  
  def ensure_fresh_config!
    clean_test_config!
    call_init
  end
  
  def assert_file_exists path
    assert_block "#{path} does not exist" do
      File.exists? path
    end
  end
end

# Used to make private methods in a class public temporarily.
class Class
  def publicize_methods
    saved_private_instance_methods = self.private_instance_methods
    self.class_eval { public *saved_private_instance_methods }
    yield
    self.class_eval { private *saved_private_instance_methods }
  end
end
