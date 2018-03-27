class Trie
  class Node
    attr_accessor :children, :is_word
    def initialize
      @children = {}
      @is_word = false
    end

    def [](key)
      children[key]
    end

    def create(key)
      children[key] ||= Node.new
    end

    def inspect
      "#{'w ' if is_word}#{children.keys.join}"
    end
  end

  attr_reader :root

  def initialize()
      @root = Node.new
  end


    def insert(word)
      v = root
      word.each_char do |c|
        v = v.create(c)
      end
      v.is_word = true
    end


    def search(word)
      v = root
      word.each_char do |c|
        v = v[c]
        break if v.nil?
      end
      v ? v.is_word : false
    end

    def starts_with(prefix)
      v = root
      prefix.each_char do |c|
        v = v[c]
        break if v.nil?
      end
      v ? (v.is_word || v.children.any?) : false
    end

    def inspect
      root.inspect
    end

end

# Your Trie object will be instantiated and called as such:
# obj = Trie.new()
# obj.insert(word)
# param_2 = obj.search(word)
# param_3 = obj.starts_with(prefix)

if defined? RSpec
  RSpec.describe 'trie0' do
    it 'works' do
      t = Trie.new
      expect(t.search('a')).to be_falsey
      expect(t.starts_with('a')).to be_falsey

      t.insert('abba')
      t.insert('abandon')
      expect(t.search('a')).to be_falsey
      expect(t.search('abba')).to be_truthy
      expect(t.starts_with('a')).to be_truthy
      expect(t.starts_with('ab')).to be_truthy
      expect(t.starts_with('abb')).to be_truthy
      expect(t.starts_with('abba')).to be_truthy
      expect(t.starts_with('abbaz')).to be_falsey

      expect(t.starts_with('aba')).to be_truthy
      expect(t.starts_with('aban')).to be_truthy
      expect(t.starts_with('abandon')).to be_truthy
      expect(t.starts_with('abandonz')).to be_falsey

    end
  end
end