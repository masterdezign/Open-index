# <penkovsky at mail dot ua>

# Not supported. Avoid using this. Prefer positional_indexer
# If you need exact phrase search you may also make phrasal preprocessing
# like "a b" => a \1 b

module OpenIndex

  require 'lib/handlers/simple/simple_index'
  require 'lib/handlers/simple/two_word_index'
  require 'lib/indexers/indexer'
  require 'lib/utils/normalizer'
  require 'lib/utils/query'

  # Combined indexer that has two types of indexes
  # two word for exact phrase search and
  # simple for one word phrase seach with AND OR NOT operators
  class TwoWordIndexer < Indexer
    include Query
    include Normalizer

    def init
      @handlers = {
        'simple' => SimpleIndex.new,
        'two_word' => TwoWordIndex.new
      }
    end
    
    def index_word word, doc_id
      @handlers.each { |hi, h| h.add word, doc_id }
    end
    
    # Does phrase preprocessing.
    # Delegates exact phrases to two-word index
    # and delegates prepared one-word phrases to simple index.
    # Then returns rearranged results.
    def search phrase, callback = nil
      
      and_phrases, or_phrases, not_phrases, two_word_phrases = get_and_or_not_exact_of phrase
      
      res = nil
      
      two_word_phrases.each do |phrase|
          res = List::chain res, @handlers['two_word'].search(phrase)
      end
      
      if not and_phrases.empty?
          res = List::chain res, @handlers['simple'].search_and(and_phrases)
      end
      
      or_phrases.each do |or_p|
          res = List::chain res, @handlers['simple'].search_or(or_p)
      end
      
      except = @handlers['simple'].search_and not_phrases
      
      final_result = []
      # finally filter pages not to show and return
      # real document names
      prefinal_ = List::NOT(res, except)
      if prefinal_
        prefinal_.each { |x| final_result |= [@manager.get_by_id(x)] }
      else
        puts 'warning: empty prefinal result'
      end
      
      # callback may be used for postfiltration etc.
      if callback
        final_result = callback final_result
      end
      
      return final_result
    end
  end
end
