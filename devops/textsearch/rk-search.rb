class String
  def rk_search(pattern)
    pos = 0
    h_self = self[0...pattern.length].rhash
    h_pattern = pattern.rhash
    until pos > length-pattern.length
      match, h_self = hash_compare(h_self, h_pattern, pattern.length, pos)
      return match if match && self[pos...pos+pattern.length] == pattern
      pos += 1
    end
  end
  def rhash(base=101)
    (0...length).inject(0) { |mem, i| mem + self[length-1-i].ord*base**(i) }
  end
  def hash_compare(h_self, h_pattern, len, pos)
    h_self == h_pattern ? pos : [nil, next_hash(h_self, len, pos)]
  end
  def next_hash(h_self, len, pos, base=101)
    return nil unless self[pos+len]
    (h_self - self[pos].ord*base**(len-1))*base + self[pos+len].ord
  end
end
