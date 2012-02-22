# <penkovsky at mail dot ua>

=begin
dic => {
    index_1 => [val_1,val_2,...],
    ...
    index_n => [...]
}
=end

def add_to_list dic, index, val
  if dic[index]
    # assure the val is not more than once in the list
    # in case some vals have couple of index occurances
    if not dic[index].index val
        dic[index].push val
    end
  else
    dic[index] = [val]
  end
end

module OpenIndex

  # DRY principle
  class BaseIndex
    def initialize
        @dic = Hash.new
    end

    def add ind, file
      add_to_list @dic, ind, file
    end

    def find ind
        # @returns list of documents containing ind
        res = @dic[ind]
        if res then return res end
        return []
    end
  end

end
