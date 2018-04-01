class GroupReader
  attr_accessor :s, :i
  def initialize(s)
    @s = s
    @i = -1
  end

  def next
    @i += 1
    return nil if eof
    cur = @s[i]
    result = [cur]
    while @s[i+1] == cur
      result << cur
      @i += 1
    end
    result.join
  end

  def eof
    @i >= @s.size
  end
end

def expressive_words(s, words)
  count = 0
  words.each do |word|
    template = GroupReader.new(s)
    candidate = GroupReader.new(word)
    t = template.next
    c = candidate.next
    valid = true
    while t && c

      if (t[0] != c[0]) || (t.size != c.size && t.size <= 2) || (t.size < c.size)
        valid = false
        break
      end
      t = template.next
      c = candidate.next
    end
    valid = false if template.eof != candidate.eof
    count += 1 if valid
  end
  count
end

if defined? RSpec
  RSpec.describe 'problem' do
    gr = GroupReader.new('abbcccde')
    it 'works' do
      expect(gr.next).to eql('a')
      expect(gr.next).to eql('bb')
      expect(gr.next).to eql('ccc')
      expect(gr.next).to eql('d')
      expect(gr.next).to eql('e')
      expect(gr.next).to be_nil
    end
  end

  RSpec.describe 'problem' do
    test_cases = [
      { input: ['aaa',['a']], output: 1},
      { input: ['aaaa',['aaa']], output: 0},
      { input: ['aaaaa',['aaaa']], output: 0},
      { input: ['a',['b']], output: 0},
      { input: ['aa',['a']], output: 0},
      { input: ['heeellooo',['hello']], output: 1},
      { input: ['heeellooo',['hello', 'hi', 'helo']], output: 1},
      { input: ['heeellllooo',['helo', 'hello']], output: 2},

      {
        input: ['dddiiiinnssssssoooo', ['dinnssoo','ddinso','ddiinnso','ddiinnssoo','ddiinso','dinsoo','ddiinsso','dinssoo','dinso']],
        output: 3
      },

      {
        input: ['dddiiiinnssssssoooo', ['dinnssoo','ddinso','ddiinnso','ddiinnssoo','ddiinso','dinsoo','ddiinsso','dinssoo','dinso']],
        output: 3
      },
      {
        input: ["aaa", ["aaaa"]],
        output: 0
      }
    ]

    test_cases.each do |input:, output:|
      it '#{input} => #{output}' do
        expect(expressive_words(*input)).to eql(output)
      end
    end
  end
end