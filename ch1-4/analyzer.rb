#!/usr/bin/env  ruby

stopwords = %w[the a by on for of are with just but and to the my I has some in
  на в из с но к как где не там Там И и На Под под Где где о во]

if ARGV.empty?
  print "Please choose the file to analyze: "
  fname = gets.chomp
else
  fname = ARGV.first
end

begin
  file_with_extension = Dir.glob("#{fname}.*").first
  raise Errno::ENOENT, "File not found" if file_with_extension.nil?
  lines = File.readlines(file_with_extension)
rescue Errno::ENOENT => e
  puts "Error: #{e.message}"
  exit 1
end

text = lines.join

def contains_russian_letters?(text)
  russian_range = /[\u0410-\u044F]/
  text.each_char { |char| return true if char.match?(russian_range) }

  false
end

line_count = lines.count
text_length = text.length
text_length_without_spaces = text.gsub(/\s+/, "").length
word_count = text.split(/\s+/).count
keyword_count = text.split(/\s+/).count { |word| word unless stopwords.include?(word) }
keyword_percentage = (keyword_count.to_f / word_count * 100).to_i
sentence_count = text.split(/[\.\?\!]/).count
paragraph_count = text.split("\n\n").count
average_sentences_per_paragraph = "%.2f" % (sentence_count.to_f / paragraph_count)
average_words_per_sentence = "%.2f" % (word_count.to_f / sentence_count)

sentences = text.gsub(/\s+/, " ").split(/[\.\?\!]/).map(&:strip)
one_third = sentences.count / 3
sentences_sorted = sentences.sort_by(&:length)
ideal_sentences = sentences_sorted.slice(one_third, one_third + 1)
ideal_sentences = ideal_sentences.select { |sentence| sentence =~ /is|are/ } unless contains_russian_letters?(text)
ideal_sentences = sentences.select { |sentence| ideal_sentences.include?(sentence) }

puts "Analyzing '#{file_with_extension}':",
  "- Line count is #{line_count}.",
  "- Text total character count is #{text_length}.",
  "- Text count without newlines and spaces is #{text_length_without_spaces}.",
  "- There are #{word_count} words.",
  "- there are #{keyword_count} key words. It is #{keyword_percentage}% of all words.",
  "- There are #{sentence_count} sentences.",
  "- There are #{paragraph_count} paragraphs.",
  "- Average number of sentences per paragraph is #{average_sentences_per_paragraph}.",
  "- Average number of words per sentence is #{average_words_per_sentence}."
puts "Summary follows: #{ideal_sentences.join(". ")}."
