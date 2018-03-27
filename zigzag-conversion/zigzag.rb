# @param {String} s
# @param {Integer} num_rows
# @return {String}
def convert(s, num_rows)
  return s if num_rows == 1
  delta = 0
  step = 2 * num_rows - 2
  prefix = 0
  result = Array.new(s.size)
  s.size.times do |k|
    candidate = (k - prefix) * step + delta
    if candidate >= s.size
      prefix = k
      delta += 1
      candidate = (k - prefix) * step + delta
    end
    result[k] = s[candidate]
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