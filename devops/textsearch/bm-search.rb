class String
  def bm_search(pattern)
    pos = 0
    until pos > length-pattern.length
      match, pos = bm_compare(pattern, pos)
      return match if match
    end
  end
  def bm_compare(pattern, pos)
    (pattern.length-1).downto(0) do |i|
      if self[pos+i] != pattern[i]
        shift = pattern[0...i].bm_shift(self[pos+i]) || i + 1
        return nil, pos + shift
      end
    end
    pos
  end
  def bm_shift(chr)
    length.times { |pos| return pos + 1 if self[-1-pos] == chr }
    nil
  end
end
