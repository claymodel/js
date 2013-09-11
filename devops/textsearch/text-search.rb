#!/opt/local/bin/ruby1.9
#-*-encoding: utf-8-*-
require "test/unit"
require "strscan"
 
class String
def self.method_added(name)
class_variable_set("@@#{$`}", 0) if name =~ /_compare$/
end
 
def self.counter
class_variables.sort.inject({}) { |h, cv| h[cv[/\w+/]] = class_variable_get(cv); h }
end
 
def search(pattern, algorithm, n=1)
case algorithm
when :ngi then ngi_search(pattern, n)
when :rk then rk_search(pattern)
else
pos, from = 0, 0
until pos > length-pattern.length
match, pos, from = send("#{algorithm}_compare", self, pattern, pos, from)
return match if match
end
end
end
 
private
def power_compare(text, pattern, pos, from)
pattern.each_char.with_index do |chr, i|
@@power += 1
return nil, pos+1, 0 unless chr == text[pos+i]
end
pos
end
def bm_compare(text, pattern, pos, from)
(pattern.length-1).downto(0) do |i|
@@bm += 1
if text[pos+i] != pattern[i]
shift = bm_shift(text[pos+i], pattern[0...i]) || i + 1
return nil, pos + shift, 0
end
end
pos
end
 
def bm_shift(chr, pat)
pat.length.times { |pos| return pos + 1 if pat[-1-pos] == chr }
nil
end
 
def kmp_compare(text, pattern, pos, from)
(from..(pattern.length-1)).each do |i|
@@kmp += 1
if text[pos+i] != pattern[i]
return nil, pos+1, 0 if i == 0
shift, from = count_sequence(pattern[0...i])
if shift
return nil, pos+i-shift, from
else
return nil, pos+i, 0
end
end
end
pos
end
 
def count_sequence(text)
shift = 1
until shift >= text.length
if text[0] == text[shift]
match = 1
until shift+match >= text.length
text[match] == text[shift+match] ? match += 1 : break
end
return text.length-shift, match
end
shift += 1
end
end
 
def ngi_search(pattern, n)
indices = index_table(n)[pattern[0...n]]
until indices.empty?
match = ngi_compare(self, pattern, indices.shift)
return match if match
end
end
 
def ngi_compare(text, pattern, pos)
pattern.length.times do |i|
@@ngi += 1
return nil if text[pos+i] != pattern[i]
end
pos
end
 
def index_table(n)
q = Hash.new{ |h, k| h[k] = [] }
self.split(//).each_cons(n).with_index { |chr, i| q[chr.join] << i }
q
end
 
def rk_search(pattern)
h_self, h_pattern = [self[0...pattern.length], pattern].map { |s| rhash s }
pos, from = 0, 0
until pos > length-pattern.length
match, pos, h_self = rk_compare(h_self, h_pattern, self, pattern, pos)
return match if match
end
end
 
def rk_compare(h_self, h_pattern, text, pattern, pos)
@@rk += 1
unless h_self == h_pattern && text[pos...pos+pattern.length] == pattern
return nil, pos+1, next_hash(text, h_self, pattern.length, pos)
end
pos
end
 
def rhash(str, base=101)
(0...str.length).inject(0) { |mem, i| mem + str[str.length-1-i].ord*base**(i) }
end
 
def next_hash(text, h_self, len, pos, base=101)
return nil unless text[pos+len]
(h_self - text[pos].ord*base**(len-1))*base + text[pos+len].ord
end
end
 
@@time = []
class TestSearchs < Test::Unit::TestCase
def setup
@text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur ABC ABCDAB ABCDABCDABDE susususususumsu abcdefgabcdefghijabcdefghijk axacacdae sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.&" * 10
@words = ["Lorem", "sum", "fugiat", "ut aliquip", "&", "t, c", " m", "o ", "ABCDABD", "acac"]
@nowords = ["hello", "ipsumd", "Velit", "&.", "t D", "veniam,,", "abcdefghijkabcdefghijk"]
@st = Time.now
end
 
def teardown
@@time << Time.now - @st
end
 
def test_power_search
@words.each do |wd|
assert_equal(@text.index(wd), @text.search(wd, :power))
end
@nowords.each do |wd|
assert_nil(@text.search(wd, :power))
end
end
def test_bm_search
@words.each do |wd|
assert_equal(@text.index(wd), @text.search(wd, :bm))
end
@nowords.each do |wd|
assert_nil(@text.search(wd, :bm))
end
end
def test_kmp_search
@words.each do |wd|
assert_equal(@text.index(wd), @text.search(wd, :kmp))
end
@nowords.each do |wd|
assert_nil(@text.search(wd, :kmp))
end
end
def test_ngi_search
@words.each do |wd|
assert_equal(@text.index(wd), @text.search(wd, :ngi))
end
@nowords.each do |wd|
assert_nil(@text.search(wd, :ngi))
end
end
 
def test_rk_search
@words.each do |wd|
assert_equal(@text.index(wd), @text.search(wd, :rk))
end
@nowords.each do |wd|
assert_nil(@text.search(wd, :rk))
end
end
end
 
END{END{
res = String.counter
res.each do |k, v|
print "%s\t%8d times(%.4f) %.4f sec\n" % [k, v, v*1.0/res["power"], @@time.shift]
end
}}