# <penkovsky at mail dot ua>

require 'test/unit'
require 'lib/utils/gram'

class GramTest < Test::Unit::TestCase  
  def test_gram
    assert gram('castle', n = 3) == ["$ca", "cas", "ast", "stl", "tle", "le$"]
    assert gram('castle', n = 4) == ["$cas", "cast", "astl", "stle", "tle$"]
  end
end
