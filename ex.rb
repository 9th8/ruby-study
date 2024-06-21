#!/usr/bin/env  ruby

`cat /etc/passwd`.split("\n").reject { |element| element.start_with?("#") }
  .collect { |line| "#{line.split(":").first} #{line.split(":").last}" } => z

puts z[1]
