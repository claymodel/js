class String
  def power_search(pattern)
    pos = 0
    until pos > length-pattern.length
      match = compare(pattern, pos)
      return match if match
      pos += 1
    end
  end
  def compare(pattern, pos)
    pattern.each_char.with_index do |chr, i|
      return nil unless chr == self[pos+i]
    end
    pos
  end
  def compare_with_scanner(pattern, pos)
    str = StringScanner.new(self)
    str.pos = pos
    pattern.each_char do |chr|
      return nil unless str.scan /#{Regexp.escape(chr)}/
    end
    pos
  end
end

