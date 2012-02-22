# <penkovsky at mail dot ua>

# Avoid using this. Prefer positional_index

require 'lib/handlers/simple/base_index'
require 'lib/utils/list'

module OpenIndex
  class TwoWordIndex < BaseIndex
    
    # super method initialize
    
    def add word, file
        if file == @last_file
           combin = @last_word + ' ' + word
           super combin, file
        else
           @last_file = file
        end
        
        @last_word = word
    end
    
    # super method find two_words
    
    def search phrase
    # @param phrase is a normalized string of space separated words
        #puts "@",phrase
        res = nil
        prev_word = nil
        phrase.split.each do |w|
            if prev_word
                search_index = "#{prev_word} #{w}"
                tmp_res = self.find search_index
                if !res
                    res = tmp_res
                else
                    res = List::send :AND, res, tmp_res
                end
            end
            prev_word = w
        end
        
        return res
    end
  end
end
