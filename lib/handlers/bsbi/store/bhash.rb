# Packs Int32 blocks ready for write
def _prepare mem
  r = []; prev = []; count = 0
  # sorted order
  mem.sort.map do |m,i|
    # prevents tuple repeating
    if prev != [m,i]
      r << m << i
      count += 1
      prev = [m,i]
    end
  end
  format = "I"+(count * 2).to_s
  return r.pack(format)
end

# Helper class for merge process
# Incapsulates external input logic
class BlockHandler
  attr :word_id
  attr :doc_id
  CHUNK_SIZE = 8 # TWO INTEGERS
  
  def initialize file
    @name = file
    @file = File.open(@name)
    @finished = false
    next_rec
  end
  
  def next_rec
    if @finished
      return
    end
    
    rec = @file.read CHUNK_SIZE
    
    if rec
      @word_id, @doc_id = rec.unpack("I2")
    else
      @word_id, @doc_id = nil, nil
      close
    end
  end
  
  def close
    if @finished: return false end
    @file.close
    @finished = true
    return true
  end
  
  def destroy
    close
    File.unlink @name
  end
end

# Implements BSBI algorithm
class BHash
  MAX_LEN = 40_000

  # should be called after indexing finished
  # if not it is called from indexing operator first time
  def merge
    def _open_block_files
      files = []
      find_all_block_files.each { |bf| files << BlockHandler.new(bf) }
      return files
    end
    def _merge_block_files block_files, out_file
      # returns minimal word_id or nil if all files finished
      def _find_min_word_id block_files
        min_word_id = nil
        block_files.each do |bf|
          if bf.word_id
            if not min_word_id
              min_word_id = bf.word_id
            elsif min_word_id > bf.word_id
              min_word_id = bf.word_id
            end
          end
        end
        return min_word_id
      end
      
      o = File.new(out_file, 'wb')
      while true
        cur_id = _find_min_word_id block_files
        if not cur_id then break end
        mem = []
        block_files.each do |bf|
          while bf.word_id == cur_id
            mem << [bf.word_id, bf.doc_id]
            bf.next_rec
          end
        end
        o.syswrite _prepare mem
      end
      o.close
    end
    
    def _destroy block_files
      block_files.each { |bf| bf.destroy }
    end
    
    flush # everything was left
    bfiles = _open_block_files
    _merge_block_files bfiles, @pref
    _destroy bfiles
    @mode = :read # TODO concerns separation for indexers and servers (no :read/:write modes)
  end

  def reset
    @mem = []
  end

  def initialize file
    @files = 0
    # prefix for temporary indexes
    @pref = file
    # first mode :write, after :read for read only
    @mode = :write
    reset
  end

  # Flushes memory buffer to disk
  def flush
    # Temp file gets name <prefix>_$i
    file_name = "#{@pref}_#{@files.to_s}"
    File.open(file_name, "w") { |f| f.syswrite _prepare @mem }
    @files += 1
    reset
  end

  def [](index)
    if @mode == :write
      merge
    end
    return "TODO indexing operator"
  end

  def []=(index, value)
    if @mode == :read then raise "Indexing was finished. Read only mode." end
    @mem << [index, value]
    if @mem.length == MAX_LEN
      flush
    end
  end

  private
  def find_all_block_files
    return Dir.glob("#{@pref}_*")
  end
end
