# <penkovsky at mail dot ua>

require 'test/unit'
require 'lib/handlers/simple/base_index'

module Test
include OpenIndex

  class BaseIndexTest < Test::Unit::TestCase
    def test_add_to_list
      a = Hash.new
      add_to_list a, 3, 2
      assert a == {3=>[2]}
      add_to_list a, 3, 5
      assert a == {3=>[2,5]}
    end

  end
end
