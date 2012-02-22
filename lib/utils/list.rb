# <penkovsky at mail dot ua>

# Generic operations with lists
# OR, AND, NOT

class List
    def self.AND a, b
    # @returns intersection of two lists
        return a & b
    end
    
    def self.OR a, b
    # @returns concatenation of two lists
        return a | b
    end
    
    def self.NOT a, b
    # @returns alements from a which are not present in b
        
        b.each do |bad|
            a.delete_if {|x| x == bad}
        end
        
        return a
    end
    
    # DRY principle
    # Intersects next_ & prev_ if prev_ != nil
    # else returns next_
    def self.chain prev_, next_
        if prev_
            return List::AND prev_, next_
        # if prev is nil that means no search was before
        else return next_
        end
    end
    
end
