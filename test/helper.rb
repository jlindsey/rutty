require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rutty'

class Test::Unit::TestCase
  def call_init
    %x(#{File.join File.dirname(__FILE__), '..', 'bin', 'rutty'} init)
  end
end
