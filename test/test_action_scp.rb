require 'helper'

class TestActionSCP < Test::Unit::TestCase
  context "The 'rutty scp' action" do
    setup { ensure_fresh_config! }
    teardown { clean_test_config! }
    
  end
end
  