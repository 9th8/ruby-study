#! /usr/bin/env ruby

require "optparse"
parser = OptionParser.new do |opts|
  opts.on("-h", "--help", "# Displays this message.") do
    puts opts
    exit
  end
end
parser.banner = "Usage: #{File.basename($PROGRAM_NAME)} file.madlib"

begin
  parser.parse!
rescue OptionParser::ParseError => e
  puts e.message
  puts parser
  exit 1
end

file = ARGV.shift

if file.empty?
  puts "#{File.basename($PROGRAM_NAME)}: error: .madlib file was not provided."
  puts parser.banner
  exit 1
end
warn "#{File.basename($PROGRAM_NAME)}: Cannot open '#{file}'. No such file." unless File.exist?(file)

madlib = File.readlines(file).map do |line|
  line.gsub!(/\(\([^)]*\)\)/).each do |placeholder|
    puts "Name #{placeholder.tr("()", "")}:"
    gets.chomp
  end
  line
end

puts madlib
