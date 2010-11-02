require 'helper'

class TestHelpers < Test::Unit::TestCase
  context "The Rutty::Helpers module" do
    setup do
      class Testing
        include Rutty::Helpers
      end
      
      @obj = Testing.new
    end
    
    should "mixin its helper methods" do
      assert_respond_to @obj, :check_installed!
      assert_respond_to @obj, :get_version
    end
    
    should "get the correct version" do
      assert_equal @obj.get_version, Rutty::Version::STRING
    end
    
    should "correctly check the installation status" do
      if File.exists? Rutty::Consts::CONF_DIR
        %x(mv #{Rutty::Consts::CONF_DIR} #{Rutty::Consts::CONF_DIR}.bak)
      end
      
      assert_raise Rutty::NotInstalledError do 
        @obj.check_installed!
      end
      
      if File.exists? "#{Rutty::Consts::CONF_DIR}.bak"
        %x(mv #{Rutty::Consts::CONF_DIR}.bak #{Rutty::Consts::CONF_DIR})
      end
    end
  end
end
