# https://adventofcode.com/2025/day/1


# Part 1 -----------------------------------------------------------------------
dial = (0..99).to_a.rotate(50)
password_counter = 0
input_lines = File.readlines("#{__dir__}/input.txt").map(&:strip)

password = input_lines.map do |line|
  direction = line[0]
  amount = line[1..-1].to_i

  case direction
  when "L"
    dial.rotate!(amount)
  when "R"
    dial.rotate!(-amount)
  end

  dial.first.zero? ? 1 : 0
end.sum

puts password # 1158

# Part 2 -----------------------------------------------------------------------

def password2(lines, start: 50)
  position = start

  lines.map.with_index do |line, i|
    direction = line[0]
    amount = line[1..-1].to_i
    initial_position = position

    zeroes, remaining_clicks = amount.divmod(100)
    initial_zeroes = zeroes

    case direction
    when "R"
      zeroes += 1 if position + remaining_clicks >= 100
      position = (position + remaining_clicks) % 100
    when "L"
      zeroes += 1 if !position.zero? && position - remaining_clicks <= 0
      position = (position - remaining_clicks) % 100
    end

    zeroes
  end.sum
end

# Tests

def define_test(name:, expected:, &block)
  result = block.call
  if result != expected
    puts "", "❌ FAILED: #{name}", "Expected: #{expected}, Actual: #{result}"
  else
    puts "", "✅ #{name}"
  end
end

define_test(name: "Counts when left and lands on zero", expected: 1) do
  password2(["L50"], start: 50)
end

define_test(name: "Counts when left and passes zero", expected: 1) do
  password2(["L51"], start: 50)
end

define_test(name: "Counts when left and passes zero overflow", expected: 2) do
  password2(["L151"], start: 50)
end

define_test(name: "Counts when left and passes zero overflow and lands on 0", expected: 2) do
  password2(["L150"], start: 50)
end

define_test(name: "Counts when right and lands on zero", expected: 1) do
  password2(["R50"], start: 50)
end

define_test(name: "Counts when right and passes zero", expected: 1) do
  password2(["R51"], start: 50)
end

define_test(name: "Counts when right and passes zero overflow", expected: 2) do
  password2(["R151"], start: 50)
end

define_test(name: "Counts when right and passes zero overflow and lands on 0", expected: 2) do
  password2(["R150"], start: 50)
end

define_test(name: "Passes example", expected: 6) do
  password2(%w[L68 L30 R48 L5 R60 L55 L1 L99 R14 L82],
            start: 50)
end

puts "Password: #{password2(input_lines)}" # 6860
