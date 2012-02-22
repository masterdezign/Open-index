# <penkovsky at mail dot ua>

require 'lib/utils/list'
require 'lib/utils/id_manager'
require 'lib/handlers/bsbi/store/bhash'
require 'config/index.rb'

module OpenIndex
  # The main concept is that it should 
  # find only conjunctions ie. A & B & C
  # or disjunctions ie. X OR Y OR Z
  # where A..C,X..Z are one-word phrases
  class BSBISimpleIndex

    def initialize
        @dic = BHash.new "#{INDEX_DIR}/index"
        @term_dic = IdManager.new
    end
    
    def add term, file_id
      term_id = @term_dic.reg term
      @dic[term_id] = file_id
    end
    
    def find ind
      raise "TODO"
    end
    
    def finish
      puts "Saving term dict..."
      @term_dic.save "#{INDEX_DIR}/terms"
      puts "Merging..."
      @dic.merge
      puts "Merge finished" # Try jrubyc
    end
  end
end
