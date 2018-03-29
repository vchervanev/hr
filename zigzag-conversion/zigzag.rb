class PositionCalculator
  def initialize(step:, rows:, size:)
    @step = step
    @rows = rows
    @size = size
    @wave = 0
    @row = 0
    @first = nil
  end

  def next
    pos = nil
    if middle_row?
      if @first.nil?
        pos = @row
        @first = true
      elsif @first
        pos = @step - @row
        @first = false
      else
        @first = nil
        @wave += 1
        return self.next
      end
    else
      if @first.nil?
        pos = @row == 0 ? 0 : @step/2
        @first = true
      else
        @wave += 1
        @first = nil
        return self.next
      end
    end

    result = @wave * @step + pos
    if result < @size
      return result
    else
      @row += 1
      @first = nil
      @wave = 0
      return self.next
    end
  end

  private

  def middle_row?
    @row > 0 && @row < @rows - 1
  end
end

# @param {String} s
# @param {Integer} num_rows
# @return {String}
def convert(s, num_rows)
  return s if num_rows == 1
  step = 2 * num_rows - 2
  result = Array.new(s.size)

  pc = PositionCalculator.new(step: step, rows: num_rows, size: s.size)
  s.size.times do |k|
    result[k] = s[pc.next]
  end
  result.join
end

if defined? RSpec
  RSpec.describe do
    use_cases =
      [
        ['abcd', 3, 'abdc'],
        ['abc', 3, 'abc'],
        ['ab', 3, 'ab'],
        ['a', 3, 'a'],
        ['', 3, ''],
        ['abcde', 1, 'abcde'],
        ['a', 2, 'a'],
        ['ab', 2, 'ab'],
        ['abc', 2, 'acb'],
        ['abcd', 2, 'acbd'],
        ['abcde', 2, 'acebd'],
        ['abcde', 3, 'aebdc'],
        ['abcdefghijklm', 4, 'agmbfhlceikdj']
      ]

    use_cases.each do |input, size, result|
      it "#{input} // #{size} => #{result}" do
        expect(convert(input, size)).to eq(result)
      end
    end
  end
end