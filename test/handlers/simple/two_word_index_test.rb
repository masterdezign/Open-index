# <penkovsky at mail dot ua>

require 'test/unit'
require 'lib/handlers/simple/two_word_index'

module Test
include OpenIndex

  class TwoWordIndexMock < TwoWordIndex
      attr :dic
  end

  class TwoWordIndexTest < Test::Unit::TestCase
    # For every test this method is called
    def setup
      @t = TwoWordIndexMock.new
      @t.add 'b', 1
      @t.add 'a', 1
      @t.add 'c', 1
      @t.add 'a', 2
      @t.add 'c', 2
      @t.add 'c', 2
    end

    def test_add
      assert @t.dic == {"b a" => [1], "a c" => [1, 2], 'c c' => [2]}
    end
    
    def test_find
      assert @t.find('c c') == [2]
      assert @t.find('not existing') == []
    end
    
    def test_search
      assert @t.search('a c') == [1,2]
      assert @t.search('a c c') == [2]
    end
  end
end
