# <penkovsky at mail dot ua>

require 'lib/handlers/simple/base_index'
require 'lib/utils/list'

module OpenIndex
  # The main concept is that it should 
  # find only conjunctions ie. A & B & C
  # or disjunctions ie. X OR Y OR Z
  # where A..C,X..Z are one-word phrases
  class SimpleIndex < BaseIndex

      # super method initialize
      
      # super method add
      
      # super method find ind

      def search_or words
          # @param words is a list of equivalent words (OR classes)
          # where every word is a normalized string without spaces
          res = []
          words.each do |w|
              res = List::OR res, self.find(w)
          end
          return res
      end
      
      def search_and words
          # @param words is a list of equivalent words (AND classes)
          # where every word is a normalized string without spaces
          # TODO: with profiler check what search order gives the optimal
          # speed
          res = nil
          words.each { |w| res = List::chain res, self.find(w) }
          
          if res then return res end
          return []
      end
  end
end
