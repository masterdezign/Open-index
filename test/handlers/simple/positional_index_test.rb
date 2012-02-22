# <penkovsky at mail dot ua>

require 'test/unit'
require 'lib/handlers/simple/positional_index'

module Test
include OpenIndex

  class PositionalIndexMock < PositionalIndex
    attr :dic
  end

  class PositionalIndexTest < Test::Unit::TestCase
    def setup
      @x = PositionalIndexMock.new
      @x.add 'word', 1, 11
    end
    
    def test_add_to_dic
      a = Hash.new
      add_to_dic a, 5, 1, 2
      assert a == {5=>{1 => [2]}}
      add_to_dic a, 5, 1, 5
      assert a == {5=>{1 => [2, 5]}}
      add_to_dic a, 5, 2, 4
      assert a == {5=>{1 => [2, 5], 2 => [4]}}
      add_to_dic a, 1, 2, 90
      assert a == {5=>{1 => [2, 5], 2 => [4]}, 1=>{2=>[90]}}
    end
    
    def test_add
      assert @x.dic == {'word' => {1 => [11]} }
      @x.add 'word', 2, 100
      assert @x.dic == {'word' => {1 => [11], 2 => [100]} }
    end
  end
  
end
