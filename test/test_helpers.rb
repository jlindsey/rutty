require 'helper'

class TestHelpers < Test::Unit::TestCase
  context "The Rutty::Helpers module" do
    setup do
      ensure_fresh_config!
      @obj = Rutty::Runner.new TEST_CONF_DIR
    end
    
    should "mixin its helper methods" do
      assert_respond_to @obj, :check_installed!
    end
    
    should "respond to its static methods" do
      assert_respond_to Rutty::Helpers, :get_version
    end
    
    should "get the correct version" do
      assert_equal Rutty::Helpers.get_version, Rutty::Version::STRING
    end
    
    should "correctly check the installation status" do
      clean_test_config!
      
      assert_raise Rutty::NotInstalledError do 
        @obj.check_installed!
      end
    end
  end
end
