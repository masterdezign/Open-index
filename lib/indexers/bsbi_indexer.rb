# <penkovsky at mail dot ua>

module OpenIndex

require 'lib/indexers/indexer'
require 'lib/handlers/bsbi/bsbi_index'

  # Indexer using BSBI handler implementing
  # BSBI external memory algorithm
  class BSBIIndexer < Indexer
    include Query
    include Normalizer

    def init
      @handler = BSBISimpleIndex.new
    end
    
    def indexDir dirname
      super dirname
      @handler.finish
    end

  end
end
