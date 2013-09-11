class String
  def ngi_search(pattern, n=1)
    indices = index_table(n)[pattern[0...n]]
    until indices.empty?
      match = ngi_compare(pattern, indices.shift)
      return match if match
    end
  end
  def index_table(n)
    q = Hash.new{ |h, k| h[k] = [] }
    self.split(//).each_cons(n).with_index { |chr, i| q[chr.join] << i }
    q
  end
  def ngi_compare(pattern, pos)
    pattern.length.times do |i|
      return nil if self[pos+i] != pattern[i]
    end
    pos
  end
end
