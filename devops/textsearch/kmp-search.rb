class String
  def kmp_search(pattern)
    pos, from = 0, 0
    until pos > length-pattern.length
      match, pos, from = kmp_compare(pattern, pos, from)
      return match if match
    end
  end
  def kmp_compare(pattern, pos, from)
    (from..(pattern.length-1)).each do |i|
      if self[pos+i] != pattern[i]
        return nil, pos+1, 0 if i == 0
        shift, from = pattern[0...i].count_sequence
        if shift
          return nil, pos+i-shift, from
        else
          return nil, pos+i, 0
        end
      end
    end
    pos
  end
  def count_sequence
    shift = 1
    until shift >= length
      if self[0] == self[shift] 
        match = 1
        until shift+match >= length
          self[match] == self[shift+match] ? match += 1 : break
        end
        return length-shift, match
      end
      shift += 1
    end
  end
end
