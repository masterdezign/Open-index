# <penkovsky at mail dot ua>


require 'lib/utils/normalizer'

module Query
  include Normalizer
  # AND operator is just a space
  AND_OPERATOR = ' '
  # other operators
  OR_OPERATOR = 'OR'
  NOT_OPERATOR = 'NOT'
  WILDCARD_OPERATOR = '*'
  # bracket for exact (two-word search)
  BRACKET = '"'

  # Used mainly by get_and_or_not_exact_of
  def get_and_or_not_of str
      # @param str is a string (not normalized!)
      # ie. ['big','OR','middle','OR','large','sandwich','NOT','cheese']
      # @returns and_phrases -- list of normalized words
      # @returns or_phrases -- list of lists of normalized words
      # @returns not_phrases -- list of normalized words
      # actually and_phrases is the same to or_phrases but in and_phrases
      # single words have replaced or-sublists
      
      r = str.split
      
      # returns or-words and indexes of already analyzed words
      def getOr_ r
          or_= []; del_ = []; cur = []
          status = :start
          x = 0
          while x < r.length do
              if r[x] == OR_OPERATOR
                  if status == :start
                      cur = [r[x-1]]
                      status = :cont
                      del_.push x-1
                  end
                  cur.push r[x+1]
                  del_ += [x, x+1]
                  x += 2
              else
                  if status == :cont
                      status = :start
                      or_.push cur
                      cur = []
                  end
                  x += 1
              end
          end
          if not cur.empty?
              or_.push cur
          end
          return or_, del_
      end
      
      def getAndNot_ r, skip
          and_ = []; not_ = []
          r.length.times do |x|
              if not skip.include?(x)
                  # if previous or last (if x = 0) in array is NOT
                  if r[x-1] == NOT_OPERATOR
                      not_ |= [r[x]]
                  elsif r[x] != NOT_OPERATOR
                      and_ |= [r[x]]
                  end
              end
          end
          return and_, not_
      end
      
      or_phrases, skip = getOr_ r
      and_phrases, not_phrases = getAndNot_ r, skip
      
      return normalize_list(and_phrases), normalize_list(or_phrases), normalize_list(not_phrases)
  end
  
  # Returns query atoms from phrase
  def get_and_or_not_exact_of(phrase)
    two_word_phrases = [] # exact phrases from two words and up
    and_phrases, or_phrases, not_phrases = [], [], []
    
    # Divide phrase by double brackets to split
    # exact phrase search and regular seach.
    phrase.split(BRACKET).each_with_index do |p, i|
      if i.odd? and p.index(" ")
        # First priority.
        # Exact phrase search - search inside brackets.
        # It doen't matter if bracket closed.
        # Also it makes sense if there are at least
        # two words in a phrase.
        two_word_phrases.push(normalize p)
      else
        # Second priority is OR operator
        # to make sure that search query is commutating.
        # For example if it not commutating then "A OR B C" equals "A & C" OR "B & C"
        # but "C A OR B" equals "C & A" OR "B".
        # Actually it should be "C & A" OR "C & B" where OR and &
        # are symmetric.
        and_, or_, not_ = get_and_or_not_of p
        # append to found in previous iterations
        and_phrases |= and_; or_phrases |= or_; not_phrases |= not_
      end
    end
    return and_phrases, or_phrases, not_phrases, two_word_phrases
  end
  
  def wildcard_parts wild_word, n = 3
    # Divides into n-char pieces
    def divide_ part, n
      # if already small
      if part.length <= n: return [part]
      end
      
      prev = part[0..n-1]
      d_ = [prev]
      part[n..-1].each_char do |c|
        # Drop first char and append c
        prev = prev[1..-1] + c
        d_ << prev 
      end
      return d_
    end
    
    parts = []
    wildcarted = wild_word.split(WILDCARD_OPERATOR)
    wildcarted.each_with_index do |part, i|
      if part.empty? then next end # trivial case
      
      # add $ for special cases -- first and last
      if i == 0 # first
        part = "$" + part
      elsif i == wildcarted.length - 1 #last
        part = part + "$"
      end
      
      parts |= divide_ part, n
      
    end
    return parts
  end

end
