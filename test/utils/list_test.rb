# <penkovsky at mail dot ua>

require 'test/unit'
require 'lib/utils/list'

class ListTest < Test::Unit::TestCase
    def setup 
        @a = [4,1,2,3]
        @b = [1,100,4]
    end

    def test_and
        assert List::AND(@a,@b).sort == [1,4]
    end
    
    def test_or
        a = [4,1,2,3]
        b = [1,100,4]
        assert List::OR(a,b).sort == [1,2,3,4,100]
    end
    
    def test_not
        a = [4,1,2,3]
        b = [1,100,4]
        assert List::NOT(a,b).sort == [2,3]
    end
    
    def test_chain
        res = nil
        res = List::chain res, @a
        assert res == @a
        res = List::chain res, @b
        assert res.sort == [1,4]
    end
end
