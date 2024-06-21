#!/usr/bin/env  ruby

# File.readlines("/etc/passwd").reject { |line| line.start_with?("#") }
#   .map { |line| line.split(":").values_at(0, -1).join(" ") }

words = File.readlines("/usr/share/dict/words", chomp: true)
letters = ("a".."z").to_h { |l| [l, 0] }

words.each do |word|
  word.downcase.chars.each { |l| letters.has_key?(l) && letters[l] += 1 }
end

letters.sort_by { |k, v| v }.reverse!.to_h.each { |k, v| puts "#{k} => #{v}" }
