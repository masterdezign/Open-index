module OpenIndex

  require 'lib/utils/id_manager'

  # @abstract
  class IndexerBase
    # @param parsers tells both which document types to index and which
    # parsing algorithm to use (choose while instantiating any indexer type)
    def initialize parsers = nil
      @manager = IdManager.new
      @parsers = parsers
      init # call actual initializer
    end
    
    # Sets index handlers (choose while programming indexer)
    def init
      raise "#{self.class.name}.init not implemented"
    end
    
    # Index directory
    def indexDir dirname
      # TODO: apply parsers layer
      pattern = "#{dirname}/*.txt"
      Dir.glob(pattern).each do |f|
        puts "Parsing #{f}"
        id = @manager.reg f
        self.index f, id
      end
    end
    
    # Index file
    def index f, id
      IO.read(f).split.each do |w|
        index_word normalize(w), id
      end
    end
  end
end
