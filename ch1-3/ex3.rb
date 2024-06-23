#!/usr/bin/env  ruby

# File.readlines("/etc/passwd").reject { |line| line.start_with?("#") }
#   .map { |line| line.split(":").values_at(0, -1).join(" ") }

words = File.readlines("/etc/passwd", chomp: true).reject { |line| line.start_with?("#") }
letters = {}

count_letters = proc { |l| letters.has_key?(l) ? (letters[l] += 1) : (letters[l] = 1) }
words.each { |word| word.downcase.chars.each { |l| count_letters.call(l) } }

letters.sort_by { |k, v| v }.reverse_each { |k, v| puts "#{k} => #{v}" }
