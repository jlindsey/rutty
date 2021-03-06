require 'helper'

class TestActionListNodes < Test::Unit::TestCase
  context "The `rutty list_nodes' action" do
    setup { ensure_fresh_config! }
    teardown { clean_test_config! }
    
    should "report no defined nodes when no nodes are defined" do
      output = %x(#{RUTTY_BIN} list_nodes -c #{TEST_CONF_DIR} 2>&1)
      
      assert_match /#{Colors::YELLOW}No nodes defined#{Colors::CLEAR}/, output
    end
    
    should "properly list defined nodes in ASCII table format" do
      3.times { seed_nodes }
      output = %x(#{RUTTY_BIN} list_nodes -c #{TEST_CONF_DIR} 2>&1)
      output = output.split("\n")
      
      separator = /^(?:\+{1}\-+)+\+$/
      
      assert_match separator, output.shift
      assert_match /^\|\sHost\s+\|\sKey\s+\|\sUser\s+\|\sPort\s+\|\sTags\s+\|$/, output.shift
      assert_match separator, output.shift
      
      3.times do
        assert_match /^\|\slocalhost\s+\|\s#{ENV['HOME']}\/\.ssh\/id_rsa\s+\|\s#{ENV['USER']}\s+\|\s22\s+\|\slocalhost,\stest\s+\|$/o, output.shift
      end
      
      assert_match separator, output.shift
    end
    
    should "properly list defined nodes in JSON format" do
      3.times { seed_nodes }
      output = %x(#{RUTTY_BIN} list_nodes -o json -c #{TEST_CONF_DIR} 2>&1)
      
      require 'json'
      require 'yaml'
      
      json_nodes = ''
      assert_nothing_raised { json_nodes = JSON.parse(output) }
      loaded_nodes = YAML.load(File.read(TEST_NODES_CONF))
      
      assert_equal loaded_nodes.length, json_nodes.length
      
      (0..(loaded_nodes.length - 1)).to_a.each do |i|
        assert_equal loaded_nodes[i]['host'], json_nodes[i]['host']
        assert_equal loaded_nodes[i]['keypath'], json_nodes[i]['keypath']
        assert_equal loaded_nodes[i]['user'], json_nodes[i]['user']
        assert_equal loaded_nodes[i]['port'], json_nodes[i]['port']
        assert_equal loaded_nodes[i]['tags'], json_nodes[i]['tags']
      end
    end
    
    should "properly list defined nodes in XML format" do
      3.times { seed_nodes }
      output = %x(#{RUTTY_BIN} list_nodes -o xml -c #{TEST_CONF_DIR} 2>&1)
      
      require 'xmlsimple'
      
      xml_nodes = ''
      assert_nothing_raised { xml_nodes = XmlSimple.xml_in(output, { 'ForceArray' => false })['node'] }
      loaded_nodes = YAML.load(File.read(TEST_NODES_CONF))
      
      assert_equal loaded_nodes.length, xml_nodes.length
      
      (0..(loaded_nodes.length - 1)).to_a.each do |i|
        assert_equal loaded_nodes[i]['host'], xml_nodes[i]['host']
        assert_equal loaded_nodes[i]['keypath'], xml_nodes[i]['keypath']
        assert_equal loaded_nodes[i]['user'], xml_nodes[i]['user']
        assert_equal loaded_nodes[i]['port'], xml_nodes[i]['port'].to_i
        assert_equal loaded_nodes[i]['tags'], xml_nodes[i]['tags']['tag']
      end
    end
  end
end
