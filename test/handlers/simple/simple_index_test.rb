# <penkovsky at mail dot ua>

require 'test/unit'
require 'lib/handlers/simple/simple_index'

module Test
include OpenIndex

  class SimpleIndexMock < SimpleIndex
      attr :dic
  end

  class SimpleIndexTest < Test::Unit::TestCase
    # For every test this method is called
    def setup
      @t = SimpleIndexMock.new
      @t.add 'b', 1
      @t.add 'a', 1
      @t.add 'c', 1
      @t.add 'a', 2
      @t.add 'c', 2
      @t.add 'c', 2
    end

    def test_add
      assert @t.dic == {"b" => [1], "a" => [1, 2], 'c' => [1, 2]}
    end
    
    def test_find
      assert @t.find('c') == [1, 2]
      assert @t.find('b') == [1]
      assert @t.find('not existing') == []
    end
    
    def test_search_and
      assert @t.search_and('b c'.split) == [1]
    end
    
    def test_search_or
      assert @t.search_or('b c'.split) == [1, 2]
    end

  end
end
