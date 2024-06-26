#!/usr/bin/env  ruby

text = " Ruby is a great programming language. It is object oriented and has many groovy features. Some people don't
  like it, but that's not our problem! It's easy to learn. It's great. To learn more about Ruby, visit the official Ruby
  website today."

sentences = text.gsub(/\s+/, " ").split(/[\.\?\!]/).map { |i| i.strip }
one_third = sentences.count / 3
sentences_sorted = sentences.sort_by { |sentence| sentence.length }
ideal_sentences = sentences_sorted.slice(one_third, one_third + 1)
ideal_sentences = ideal_sentences.select { |sentence| sentence =~ /is|are/ }
ideal_sentences = ideal_sentences.select { |sentence| sentences.include?(sentence) }
puts "#{ideal_sentences.join(". ")}."
