# https://adventofcode.com/2025/day/2

input = File.readlines("#{__dir__}/input.txt").first.strip.split(",")

def define_test(name:, expected:, &block)
  result = block.call
  if result != expected
    puts "", "❌ FAILED: #{name}", "Expected: #{expected}, Actual: #{result}"
  else
    puts "", "✅ #{name}"
  end
end

PART_1_REGEXP = /^(\d+)\1$/

def sum_invalid_ids_matching(id_ranges_str, regexp:)
  id_ranges = id_ranges_str.map do |range_str|
    start, finish = range_str.split("-")
    (start..finish)
  end

  invalid_ids = id_ranges.each_with_object([]) do |id_range, invalid_id_arr|
    invalid_ids = id_range.select { _1.match regexp }

    invalid_id_arr.concat invalid_ids.map(&:to_i)
  end

  invalid_ids.sum
end

# Tests

define_test(name: "Returns correct sum", expected: 33) do
  sum_invalid_ids_matching(%w[11-22], regexp: PART_1_REGEXP)
end

define_test(name: "Returns correct sum when ranges without invalid", expected: 33) do
  sum_invalid_ids_matching(%w[11-22 23-32], regexp: PART_1_REGEXP)
end

example_ranges = %w[
  11-22
  95-115
  998-1012
  1188511880-1188511890
  222220-222224
  1698522-1698528
  446443-446449
  38593856-38593862
  565653-565659
  824824821-824824827
  2121212118-2121212124
]
define_test(name: "Passes example", expected: 1_227_775_554) do
  sum_invalid_ids_matching(example_ranges, regexp: PART_1_REGEXP)
end

puts "Invalid ID sum: #{sum_invalid_ids_matching(input, regexp: PART_1_REGEXP)}"

# Part 2 -----------------------------------------------------------------------

PART_2_REGEXP = /^(\d+)\1+$/

example_ranges = %w[
  11-22
  95-115
  998-1012
  1188511880-1188511890
  222220-222224
  1698522-1698528
  446443-446449
  38593856-38593862
  565653-565659
  824824821-824824827
  2121212118-2121212124
]
define_test(name: "Passes example", expected: 4_174_379_265) do
  sum_invalid_ids_matching(example_ranges, regexp: PART_2_REGEXP)
end

puts "Part 2 Invalid ID sum: #{sum_invalid_ids_matching(input, regexp: PART_2_REGEXP)}"
