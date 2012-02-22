require 'lib/handlers/simple/base_index'

"dic = {
    'index' => {
        subindex_1 => [20,50,300,...],
        ...
        subindex_n => [...]
    }
    ...
}"
def add_to_dic dic, index, subindex, val
    if dic[index] and dic[index][subindex]
        dic[index][subindex] |= [val]
    else
        if not dic[index]
            dic[index] = {subindex => [val]}
        else
            dic[index][subindex] = [val]
        end
    end
end

module OpenIndex

=begin
@dic = {
    'word' => {
        1 => [20,50,300,...],
        ...
        n => [...]
    }
    ...
}
=end
class PositionalIndex < BaseIndex

  # add info to @dic
  def add word, file, pos
    add_to_dic @dic, word, file, pos
  end
  
  # @returns dic like this
  # 'word' => {
  #    1 => [20,50,300,...],
  #    ...
  #    n => [...]
  # }
  # end
  # or empty Hash
  def find ind
    s = super ind
    if s == []: return {} end
    return s
  end
end

end
