# <penkovsky at mail dot ua>

# Checks if distance is relevant
def check_ p,q,dist
    # @param p = 1, 3, 10, 16, 18 -- list of positions of a in document
    # @param q = 7, 12, 20 -- list of positions of b in document
    # @param dist = 2 -- distance
    # @returns true as |10 - 12| <= 2
    
    # trivial AND intersection (no distance)
    if dist == nil then return true end
    
    i, j = 0, 0
    
    while i < p.length and j < q.length
        if (p[i] - q[j]).abs <= dist
            return true
        elsif p[i] < q[j]
            i += 1
        else j += 1
        end
        
    end
    return false
end

def intersect_by_distance a, b, distance
  # @params a,b -- hashes: key => docId, val => [positions list]
  # @distance -- distance for positions in a,b
  # @returns ids of documents intersecting a & b, valid documents of b with
  # position indexes
  
  res = {}

  a.each do |ak,av|
      if b.include?(ak)
          if check_(av,b[ak],distance)
              res[ak] = b[ak]
          end
      end
  end
  
  return res
end

require 'lib/handlers/simple/positional_index'
require 'lib/indexers/indexer_base'
require 'lib/utils/normalizer'
require 'lib/utils/list'

module OpenIndex

  class PositionalIndexer < IndexerBase
      include Normalizer
    
      def init
        @handler = PositionalIndex.new
      end
      
      def index f, id
      # @param f -- file
      # @param id -- assigned id
        IO.read(f).split.each_with_index do |w, pos|
          @handler.add normalize(w), id, pos
        end
      end
      
      def search phrase
        distance = nil
        words = phrase.split
        # initial results (for first word)
        res = @handler.find normalize(words.delete_at(0))
        docs = res.keys
        if words.length > 0 # one word search
          words.each do |p|
            # if control char
            if p.index('/') == 0
              distance = p[/\d+/].to_i
            # if word
            else
              res = intersect_by_distance(res, @handler.find(normalize(p)), distance)
              docs = List::AND docs, res.keys
              distance = nil
            end
          end
        end
        final_result = []
        # real document names
        docs.each { |x| final_result |= [@manager.get_by_id(x)] }
        return final_result
      end
  end

end
