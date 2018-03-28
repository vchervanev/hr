class PositionCalculator
  def initialize(step:, rows:, size:)
    @step = step
    @rows = rows
    @size = size
    @wave = -1
    @row = 0
    @first = nil
  end

  def next
    if middle_row?

    else
      @wave += 1
    end
  end

  private

  def middle_row?
    @row > 0 && @row < rows - 1
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
        ['abcd', 3, 'abcd'],
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
      ]

    use_cases.each do |input, size, result|
      it "#{input} // #{size} => #{result}" do
        expect(convert(input, size)).to eq(result)
      end
    end
  end
end