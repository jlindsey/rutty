require 'helper'

class TestActions < Test::Unit::TestCase
  context "The Rutty::Actions module" do
    should "mix in its methods" do
      r = Rutty::Runner.new
      
      assert_respond_to r, :init
      assert_respond_to r, :add_node
      assert_respond_to r, :list_nodes
      assert_respond_to r, :dsh
      assert_respond_to r, :scp
    end
  end
end
