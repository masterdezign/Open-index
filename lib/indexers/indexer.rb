# <penkovsky at mail dot ua>

module OpenIndex

  require 'lib/handlers/simple/simple_index'
  require 'lib/handlers/simple/two_word_index'
  require 'lib/indexers/indexer_base'
  require 'lib/utils/normalizer'
  require 'lib/utils/query'

  # Combined indexer that has
  # simple for one word phrase seach with AND OR NOT operators
  class Indexer < IndexerBase
    include Query
    include Normalizer

    def init
      @handler = SimpleIndex.new
    end

    def index_word word, doc_id
      @handler.add word, doc_id
    end
    
    # Does phrase preprocessing.
    # For instance, query '"One is" expected OR required OR demanded prepare OR study NOT geography'
    # is interpreted as
    # one is ... expected ... prepare
    #  OR
    # one is ... prepare ... expected
    #  OR
    # one is ... required ... prepare
    #  OR
    #     ...
    #  OR
    # one is ... demanded ... prepare
    #  OR
    #     ...
    #  OR
    # one is ... expected ... study
    #  OR
    #     ...
    #  OR
    # study ... demanded ... one is
    # And no query results should contain the word 'geography'.
    def search_ids phrase
      # TODO: to find with a help of profiler the quickest sequence of and-or-not queries
      # depending on word occurances number in the documents
      
      and_phrases, or_phrases, not_phrases = get_and_or_not_of phrase
      
      res = nil
      
      if not and_phrases.empty?
          res = List::chain res, @handler.search_and(and_phrases)
      end
      
      or_phrases.each do |or_p|
          res = List::chain res, @handler.search_or(or_p)
      end
      
      except = @handler.search_and not_phrases
      
      # finally filter pages not to show and return
      # real document names
      return List::NOT(res, except)
    end
    
    def search phrase
      ids = search_ids(phrase)
      return @manager.decode(ids)
    end
  end
end
