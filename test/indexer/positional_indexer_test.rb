# <penkovsky at mail dot ua>

require 'test/unit'
require 'lib/indexers/positional_indexer'

module Test
include OpenIndex

  class PositionalIndexerTest < Test::Unit::TestCase
    def test_intestect_by_distance
      a = {99 => [1, 3, 10, 16, 18]}
      b = {99 => [7, 12, 20], 100 => [7, 12, 20]}
      assert intersect_by_distance(a,b,2) == {99 => [7, 12, 20]}
      assert intersect_by_distance({99 => [200], 100 => [1000]},b,nil) == b
      assert intersect_by_distance(b,a,2) == {99 => [1, 3, 10, 16, 18]}
      assert intersect_by_distance(b,a,1) == {}
    end
    
    def test_check_
      a = [1, 3, 10, 16, 18]
      b = [7, 12, 20]
      assert check_(a,b,2) == true
      assert check_(b,a,2) == true
      assert check_(a,b,1) == false
      assert check_(a,b,nil) == true
    end
  end
end
