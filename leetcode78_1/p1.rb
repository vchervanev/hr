def subdomain_visits(input)
  index = Hash.new { 0 }
  input.each do |pair|
    cnt, addr = pair.split(' ')
    cnt = cnt.to_i
    current = addr
    addr.split('.').each do |sub|
      index[current] += cnt
      current.sub!(sub + '.', '')
    end
  end
  index.map { |k,v| "#{v} #{k}"}
end

if defined? RSpec
  RSpec.describe 'problem' do
    test_cases = [
      { input: [], output: []},
      { input: ['11 com'], output: ['11 com']},
      { input: ['11 a.com'], output: ['11 a.com', '11 com']},
      { input: ['11 a.b.com'], output: ['11 a.b.com', '11 b.com', '11 com']},
      { input: ['11 com', '1 org'], output: ['11 com', '1 org']},
      { input: ['11 a.com', '1 b.com'], output: ['12 com', '1 b.com', '11 a.com']},
      {
        input: ["900 google.mail.com", "50 yahoo.com", "1 intel.mail.com", "5 wiki.org"],
        output: ["901 mail.com","50 yahoo.com","900 google.mail.com","5 wiki.org","5 org","1 intel.mail.com","951 com"]
      }
    ]

    test_cases.each do |input:, output:|
      it "#{input} => #{output}" do
        expect(subdomain_visits(input).sort).to eql(output.sort)
      end
    end
  end
end