require 'helper'

class TestActionSCP < Test::Unit::TestCase
  context "The 'rutty scp' action" do
    setup do 
      ensure_fresh_config!
      seed_nodes
      
      @test_file_src = File.join(File.expand_path(TMP_DIR), 'TEST')
      @test_file_dest = @test_file_src.dup << "2"
      
      File.open(@test_file_src, 'w') { |f| f.write "Hello, this is a test." }
      
      @out = %x(#{RUTTY_BIN} scp -c #{TEST_CONF_DIR} -a #{@test_file_src} #{@test_file_dest} 2>&1)
    end
    teardown { clean_test_config! }
    
    should "correctly upload a file to a node" do
      assert_file_exists "#{@test_file_dest}"
      assert_equal "Hello, this is a test.", File.read("#{@test_file_dest}")
    end
    
    should "display the correct output" do
      assert_match /^#{Colors::GREEN}1 file uploaded in [\d\.]+ [seconds|minutes]#{Colors::CLEAR}$/, @out
    end
  end
end
