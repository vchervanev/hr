class Validator
    attr_reader :a, :b, :i, :j, :max_i, :max_j, :max_k, :median, :log
    def initialize(a1, a2, log: false)
      @a = a1
      @b = a2
      @log = log

      # amount of elements to be cut off by a median value
      n = (a1.size + a2.size)/2

      @max_i = [n, a.size].min - 1
      @max_j = [n, b.size].min - 1
      @max_k = [max_i, max_j].min + 1
    end

    # checks if k is a median point of 2 arrays
    # Results:
    #   0 yes
    #   1 k is too high
    #  -1 k is too low
    def check(k)
      raise 'invalid argument' if k > max_k
      # if k == 0 then all a1's items are included
      @i = max_i - k
      # if k == max_k then all a2's items are included
      @j = max_j - (max_k - k)
      # for any k in [1, max_i] either a1 and a2's elements are used
      ai = i != -1 ? a[i] : nil # a[i]
      bj = j != -1 ? b[j] : nil # b[j]

      aix = i + 1 < a.size ? a[i+1] : nil # a[i+1]
      bjx = j + 1 < b.size ? b[j+1] : nil # b[j+1]

      # ai < bjx && bj < aix
      a_condition = ai.nil? || bjx.nil? || ai <= bjx
      b_condition = bj.nil? || aix.nil? || bj <= aix

      result = if a_condition && b_condition
        @median = calc_median(ai, aix, bj, bjx)
        0
      elsif a_condition
        1
      else # b_condition
        -1
      end

      puts "k: #{k}: a#{[ai, aix]}, b#{[bj, bjx]}}, result: #{result}, median: #{median}" if log
      result
    end

    private

    def calc_median(ai, aix, bj, bjx)
      next_value = [aix, bjx].compact.min || 0
      selected_value = [ai, bj].compact.max || 0
      even = (a.size + b.size) % 2 == 0

      even ? (selected_value + next_value)/2.0 : next_value.to_f
    end
end

require_relative '../bsearch/main'

class Problem
  def self.solve(a, b, log: false)
    puts "#{a}\n#{b}\n" if log
    v = Validator.new(a, b, log: log)
    bs = BSearch.new(0, v.max_k, log)
    bs.search { |k| v.check(k) }

    v.median
  end
end

if defined? RSpec
  def check_sets_ij(params)
    context 'i, j' do
      params.each do |k, ij|
        it "check(#{k}) sets coordinates to #{ij}" do
          validator.check(k)
          expect([validator.i, validator.j]).to eql ij
        end
      end
    end
  end

  def check_return_value(params)
    context 'check' do
      params.each do |k, result|
        it "returns #{result} for #{k}" do
          expect(validator.check(k)).to eql(result)
        end
      end
    end
  end
  RSpec.describe 'validator' do
    context 'regular equal length arrays' do
      let(:a) { [1, 3, 5] }
      let(:b) { [2, 4, 6] }
      subject(:validator) { Validator.new(a, b) }

      it 'sets max_i' do expect(validator.max_i).to eql(2) end
      it 'sets max_j' do expect(validator.max_j).to eql(2) end
      it 'sets max_k' do expect(validator.max_k).to eql(3) end

      check_sets_ij({ 0 => [2, -1], 1 => [1, 0], 2 => [0, 1], 3 => [-1, 2] })
      check_return_value({ 0 => -1, 1 => 0, 2 => 1, 3 => 1})
    end

    context 'inequal length arrays' do
      let(:a) { [1, 2, 3, 5, 6] }
      let(:b) { [4] }
      subject(:validator) { Validator.new(a, b) }

      it 'sets max_i' do expect(validator.max_i).to eql(2) end
      it 'sets max_j' do expect(validator.max_j).to eql(0) end
      it 'sets max_k' do expect(validator.max_k).to eql(1) end

      check_sets_ij({ 0 => [2, -1], 1 => [1, 0] })
      check_return_value({ 0 => 0, 1 => 1 })
    end
    context 'inequal length arrays reverse ' do
      let(:a) { [4] }
      let(:b) { [1, 2, 3, 5, 6] }
      subject(:validator) { Validator.new(a, b) }

      it 'sets max_i' do expect(validator.max_i).to eql(0) end
      it 'sets max_j' do expect(validator.max_j).to eql(2) end
      check_sets_ij({ 0 => [0, 1], 1 => [-1, 2] })
      check_return_value({ 0 => -1, 1 => 0 })
    end

    context 'inequal length arrays reverse ' do
      let(:a) { [4, 7, 9] }
      let(:b) { [1, 2, 3, 5, 6] }
      subject(:validator) { Validator.new(a, b) }

      it 'sets max_k' do expect(validator.max_k).to eql(3) end
      check_return_value({ 0 => -1, 1 => -1, 2 => 0, 3 => 1 })
      check_return_value({ 2 => 0 })
    end

  end

  RSpec.describe 'solution' do
    use_cases = {
      'naive 1' => {
        a: [1, 2],
        b: [3, 4],
        result: 2.5,
      },
      'naive 2' => {
        a: [1, 2, 3],
        b: [4, 5],
        result: 3.0,
      },
      'naive 3' => {
        a: [1, 2],
        b: [3, 4, 5],
        result: 3.0,
      },

      'inequal length arrays, odd elements number' => {
        a: [1, 3, 5, 8, 9],
        b: [2, 4, 6, 7],
        result: 5.0,
      },
      'equal length arrays, even elements number' => {
        a: [1, 3, 5, 8],
        b: [2, 4, 6, 7],
        result: 4.5,
      },
      'inequal length arrays, even elements number' => {
        a: [1, 3, 5, 8],
        b: [2, 7],
        result: 4.0,
      },
      'smallest possible arrays' => {
        a: [1],
        b: [2],
        result: 1.5,
      },
      'smallest possible array + empty' => {
        a: [1, 5],
        b: [],
        result: 3.0,
      },
      'all equal values 2' => {
        a: [5, 5],
        b: [5, 5, 5],
        result: 5.0,
      },
      'all equal values 1' => {
        a: [5],
        b: [5],
        result: 5.0,
      },
      'all equal values 3' => {
        a: [5, 5, 5],
        b: [5, 5, 5],
        result: 5.0,
      },
      'mini input' => {
        a: [1],
        b: [],
        result: 1.0,
      },
      'empty input' => {
        a: [],
        b: [],
        result: 0.0,
      },
    }

    use_cases.each do |name, params|
      a = params[:a]
      b = params[:b]
      result = params[:result]
      it name do
        expect(Problem.solve(a, b)).to eql(result)
      end
      it name + ' reversed' do
        expect(Problem.solve(b, a)).to eql(result)
      end
    end
  end
end