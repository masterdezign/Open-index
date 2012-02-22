# <penkovsky at mail dot ua>

module OpenIndex

  require 'lib/indexers/indexer_base'
  require 'lib/handlers/simple/simple_index'
  require 'lib/utils/query'
  require 'lib/utils/normalizer'
  require 'lib/utils/gram'

  # adds n-gram indexer feature that supports single wildcard (*) search
  # used around any indexer implementing indexer interface
  class GramWrapper < IndexerBase
    include Query
    include Normalizer
    
    # @param parsers -- see IndexerBase
    # @param indexer -- kind of indexer (simple (normal, positional), bsbi, etc.) but not two_word
    def initialize indexer, parsers = nil
      super parsers
      @indexer = indexer.new
    end
    
    def init
      # Let's store grams in RAM
      @gram_handler = SimpleIndex.new
    end
    
    # Indexes file
    # Called by indexDir
    def index f, id
      IO.read(f).split.each do |w|
        w = normalize(w)
        # normal indexing -- delegation
        @indexer.index_word w, id
        # creating 3-gram index to preprocess queries
        # word containing n-gram is stored as second argument (like document_id)
        gram(w, n = 3).each { |g| @gram_handler.add(g, w) }
      end
    end
    
    def search phrase
      # delegation
      ids = @indexer.search_ids prepare_search(phrase)
      return @manager.decode(ids)
      # After the postfiltration -- TODO
      # return concatenated results
    end
    
    # Replaces wildcards with words from 3-gram index
    def prepare_search phrase
      new_phrase = []
      
      phrase.split.each do |a|
        # If something like be*r
        if a.index WILDCARD_OPERATOR
          # replace be*r with possible alternatives: bear OR beer OR bever...
          new_phrase << @gram_handler.search_and(wildcard_parts(a)).join(" #{OR_OPERATOR} ")
        else
          new_phrase << a
        end
      end
      
      return new_phrase.join ' '
    end

  end

end
