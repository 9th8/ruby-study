#!/usr/bin/env  ruby

print "Please choose the file to analyze: "
fname = gets.chomp

begin
  file_with_extension = Dir.glob("#{fname}.*").first
  raise Errno::ENOENT, "File not found" if file_with_extension.nil?
  lines = File.readlines(file_with_extension)
rescue Errno::ENOENT => e
  puts "Error: #{e.message}"
  exit 1
end

text = lines.join

puts "Analyzing '#{file_with_extension}':",
  "- Line count is #{lines.count}.",
  "- Text total character count is #{text.length}.",
  "- Text count whithout newlines and spaces is #{text.gsub(/\s+/, "").length}.",
  "- There are #{w = text.split(/\s+/).count} words.",
  "- There are #{s = text.split(/[\.\?\!]/).count} sentences.",
  "- There are #{p = text.split("\n\n").count} paragraphs",
  "- Average number of sentences per paragraph is #{"%.2f" % (s.to_f / p)}",
  "- Average number of words per sentence is #{"%.2f" % (w.to_f / s)}"
