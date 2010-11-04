require 'helper'

class TestConfig < Test::Unit::TestCase
  context "The Rutty::Config class" do
    setup { ensure_fresh_config! }
    teardown { clean_test_config! }
    
    should "respond to #load_config" do
      assert_respond_to Rutty::Config, :load_config
    end

    should "properly load the general config file" do
      require 'yaml'
      
      assert_equal YAML.load(File.open(TEST_GENERAL_CONF).read), Rutty::Config.load_config(TEST_CONF_DIR).to_hash
    end
  end
  
  context "A Rutty::Config instance" do
    setup { 
      @config = Rutty::Config.new
      @hash = { :foo => "bar", :baz => "widget" }
    }
    
    should "respond to the proper instance methods" do
      assert_respond_to @config, :update!
      assert_respond_to @config, :[]
      assert_respond_to @config, :[]=
      assert_respond_to @config, :to_hash
      assert_respond_to @config, :method_missing
    end
    
    should "properly update and return its data variable" do
      @config.update! @hash

      assert_equal @config.to_hash, @hash
    end
    
    should "properly instantiate with data" do
      config = Rutty::Config.new @hash
      assert_equal @hash, config.to_hash
    end
    
    should "properly get and set with hash operators" do
      @config[:foo] = "bar"
      assert_equal "bar", @config[:foo]
    end
    
    should "properly get and set with object operators" do
      @config.foo = "bar"
      assert_equal "bar", @config.foo
    end
  end
end
