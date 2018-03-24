class BSearch
  attr_reader :left, :right, :log

  def initialize(left, right, log=false)
    @left = left
    @right = right
    @log = log
  end

  def search
    loop do
      k = (left + right)/2
      v = yield k
      size = right - left
      print "[#{left}, #{right}], k = #{k}, v = #{v}\n" if log
      case v <=> 0
        when 0 then
          return k
        when -1 then
          @left = k + 1 if left < right
        else # +1
          @right = k - 1 if right > left
      end
      return nil if size == right - left
    end
  end

  def inspect
    "[#{left}, #{right}]"
  end
end


if defined? RSpec
  RSpec.describe 'bsearch' do

    it 'works', :aggregate_failures do
      t = (0..1000).to_a

      s = BSearch.new(t.first, t.last)
      expect(s.search { |k| k <=> 36 }).to eql(36)
      expect(s.left).to eql(36)
      expect(s.right).to eql(36)
    end
  end
end