# <penkovsky at mail dot ua>

# class is responsible for document ids
class IdManager
  def initialize
      @registry = {}
      # optimized to avoid Hash#index
      @rev_registry = {}
      @freeId = 1
  end

  # Registers new id for new name
  # else returns old id
  def reg name
    if @rev_registry[name]
      return @rev_registry[name]
    end
    curId = @freeId
    @registry[curId] = name
    @rev_registry[name] = curId
    @freeId += 1
    return curId
  end

  # Replaces array of ids with their original names
  def decode ids
    res = []
    if ids
      ids.each { |x| res |= [get_by_id(x)] }
    else
      puts 'warning: no ids found'
    end
    return res
  end

  def get_by_id id
    return @registry[id]
  end

  # TODO: JSON
  def save file_name
    f = File.new(file_name, 'w')
    f.write("{")
    @registry.each do |id, t|
      f.write("#{id}=>\"#{t.gsub('"',"'")}\",")
    end
    f.write("}")
    f.close
  end

  # TODO: def restore file_name

end
