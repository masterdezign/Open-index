# <penkovsky at mail dot ua>

require 'test/unit'
require 'lib/utils/query'

module Test
  class QueryTest < Test::Unit::TestCase
    include Query
    
    def test_wildcard_parts
      assert wildcard_parts('li*ke') == ["$li", "ke$"]
      assert wildcard_parts('lis*ke') == ["$li", "lis", "ke$"]
      assert wildcard_parts('lis*kes') == ["$li", "lis", "kes", "es$"]
      assert wildcard_parts('ara*nopho*ia') == ["$ar", "ara", "nop", "oph", "pho", "ia$"]
      assert wildcard_parts('li*') == ["$li"]
      assert wildcard_parts('*li') == ["li$"]
    end
    
    def test_get_and_or_not_of
      words = ['big','OR','middle','OR','large','sandwich','cucumber','NOT','cheese','NOT','cake'].join ' '
      and_phrases, or_phrases, not_phrases = get_and_or_not_of words
      
      assert and_phrases == ['sandwich','cucumber']
      assert not_phrases == ['cheese', 'cake']
      assert or_phrases == [['big', 'middle', 'large']]
      
      words = 'to be or not to be'
      and_phrases, or_phrases, not_phrases = get_and_or_not_of words
      assert and_phrases == ['to','be','or','not']
      
      words = 'NOT try study OR learn required OR demanded OR suffered'
      and_phrases, or_phrases, not_phrases = get_and_or_not_of words
      
      assert and_phrases == []
      assert not_phrases == ['try']
      assert or_phrases.include? ['study','learn']
      assert or_phrases.include? ['required','demanded','suffered']
    end
  end
end
