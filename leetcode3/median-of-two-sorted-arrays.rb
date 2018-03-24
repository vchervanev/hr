class Validator
    attr_reader :a, :b, :i, :j, :max_i, :max_j, :max_k
    def initialize(a1, a2)
      @a = a1
      @b = a2

      # amount of elements to be cut off by a median value
      n = (a1.size + a2.size)/2

      @max_i = [n, a.size].min - 1
      @max_j = [n, b.size].min - 1
      @max_k = [max_i, max_j].min + 1
    end

    # checks if k is a median point of 2 arrays
    # Results:
    #   0 yes
    #   1 k is too low
    #  -1 k is too high
    def check(k)
      raise 'invalid argument' if k > max_k
      # if k == 0 then all a1's items are included
      @i = max_i - k
      # if k == max_k then all a2's items are included
      @j = max_j - (max_k - k)
      # for any k in [1, max_i] either a1 and a2's elements are used
      ai = i != -1 ? a[i] : nil # a[i]
      bj = j != -1 ? b[j] : nil # b[j]

      aix = i < max_i ? a[i+1] : nil # a[i+1]
      bjx = j< max_j ? b[j+1] : nil # b[j+1]

      # ai < bjx && bj < aix
      a_condition = ai.nil? || bjx.nil? || ai < bjx
      b_condition = bj.nil? || aix.nil? || bj < aix

      if a_condition && b_condition
        0
      elsif a_condition
        -1
      else # b_condition
        1
      end
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
      check_return_value({ 0 => 1, 1 => 0, 2 => -1, 3 => -1})
    end

    context 'inequal length arrays' do
      let(:a) { [1, 2, 3, 5, 6] }
      let(:b) { [4] }
      subject(:validator) { Validator.new(a, b) }

      it 'sets max_i' do expect(validator.max_i).to eql(2) end
      it 'sets max_j' do expect(validator.max_j).to eql(0) end
      it 'sets max_k' do expect(validator.max_k).to eql(1) end

      check_sets_ij({ 0 => [2, -1], 1 => [1, 0] })
      check_return_value({ 0 => 0, 1 => -1 })
    end
    context 'inequal length arrays reverse ' do
      let(:a) { [4] }
      let(:b) { [1, 2, 3, 5, 6] }
      subject(:validator) { Validator.new(a, b) }

      it 'sets max_i' do expect(validator.max_i).to eql(0) end
      it 'sets max_j' do expect(validator.max_j).to eql(2) end
      check_sets_ij({ 0 => [0, 1], 1 => [-1, 2] })
      check_return_value({ 0 => 1, 1 => 0 })
    end

    context 'inequal length arrays reverse ' do
      let(:a) { [4, 7, 9] }
      let(:b) { [1, 2, 3, 5, 6] }
      subject(:validator) { Validator.new(a, b) }

      it 'sets max_k' do expect(validator.max_k).to eql(3) end
      check_return_value({ 0 => 1, 1 => 1, 2 => 0, 3 => -1 })
      check_return_value({ 2 => 0 })
    end

  end
end