# <penkovsky at mail dot ua>

require 'test/unit'
require 'lib/utils/normalizer'

module Test
  class NormalizerTest < Test::Unit::TestCase
    include Normalizer
    def test_normalize
      # check all unnecessary symbols removal
      # stars (*) are accepted as wildcard operators
      # TODO: revise normalize for queries and for indexing
      assert normalize("a!b. c*?!&^") == "ab c*"
      
      # numbers
      assert normalize("0123456789") == "0123456789"
      
      # check lowercase
      assert normalize("Ab C") == "ab c"
      
      # check simple plural
      assert normalize("balls") == "ball"
      
      # check obviously invalid plural removal
      assert normalize("as") == "as"
      assert normalize("Is") == "is"
      
      # check unicode (ukrainian) compatibility
      assert normalize("Аґрус і абрикос Є їжею (Test).") == "Аґрус і абрикос Є їжею test"
      
      # TODO: write downcase for UTF8 (i.e. unkrainian chars)
      # assert normalize("Аґрус і абрикос Є їжею (Test).") == "аґрус і абрикос є їжею test"
      
    end
  end
end
