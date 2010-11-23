require 'helper'

class TestActionSCP < Test::Unit::TestCase
  context "The 'rutty scp' action" do
    setup { ensure_fresh_config! }
    teardown { clean_test_config! }

    should "correctly upload a file to a node" do
      seed_nodes

      @test_file_src = File.join(File.expand_path(TMP_DIR), 'TEST')
      @test_file_dest = @test_file_src.dup << "2"

      File.open(@test_file_src, 'w') { |f| f.write "Hello, this is a test." }

      @out = %x(#{RUTTY_BIN} scp -c #{TEST_CONF_DIR} -a #{@test_file_src} #{@test_file_dest} 2>&1)
      
      assert_file_exists "#{@test_file_dest}"
      assert_equal "Hello, this is a test.", File.read("#{@test_file_dest}")
    end

    should "display the correct output on success" do
      seed_nodes

      @test_file_src = File.join(File.expand_path(TMP_DIR), 'TEST')
      @test_file_dest = @test_file_src.dup << "2"

      File.open(@test_file_src, 'w') { |f| f.write "Hello, this is a test." }

      @out = %x(#{RUTTY_BIN} scp -c #{TEST_CONF_DIR} -a #{@test_file_src} #{@test_file_dest} 2>&1)

      assert_match /^#{Colors::GREEN}localhost#{Colors::CLEAR}\n+/, @out
      assert_match /\n+#{Colors::GREEN}1 host\(s\), 0 error\(s\), \d+(?:\.\d+)? seconds?#{Colors::CLEAR}/, @out
    end

    should "display the correct output on error" do
      seed_bad_node

      @test_file_src = File.join(File.expand_path(TMP_DIR), 'TEST')
      @test_file_dest = @test_file_src.dup << "2"

      File.open(@test_file_src, 'w') { |f| f.write "Hello, this is a test." }

      @out = %x(#{RUTTY_BIN} scp -c #{TEST_CONF_DIR} -a #{@test_file_src} #{@test_file_dest} 2>&1)

      assert_match /^#{Colors::YELLOW}#{Colors::RED_BG}example\.com#{Colors::CLEAR}\s+#{Colors::RED}ERROR: Connection timeout#{Colors::CLEAR}\n+/, @out
      assert_match /\n+#{Colors::RED}1 host\(s\), 1 error\(s\), \d+(?:\.\d+)? seconds?#{Colors::CLEAR}/, @out
    end
  end
end
