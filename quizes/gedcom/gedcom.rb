#!/usr/bin/env  ruby

require "optparse"
require "yaml"

parser = OptionParser.new do |opts|
  opts.on("-h", "--help", "# Displays this message.") do
    puts opts
    exit
  end
end
parser.banner = "Usage: #{File.basename($PROGRAM_NAME)} file.ged"

begin
  parser.parse!
rescue OptionParser::ParseError => e
  puts e.message
  puts parser
  exit 1
end

file = ARGV.shift
if file.empty?
  puts "#{File.basename($PROGRAM_NAME)}: error: .ged file was not provided."
  puts parser.banner
  exit 1
end
warn "#{File.basename($PROGRAM_NAME)}: Cannot open '#{file}'. No such file." unless File.exist?(file)

segments = []
i = 0

File.readlines(file).map do |line|
  segments[i] ||= []
  segments[i] << line.chomp if /^\d/.match? line
  i += 1 if line.strip.empty?
end

segments.map do |segment|
  hash = {}
  key = []
  segment.map do |line|
    case idx = line[0].to_i
    when 0
      key[0] = line.split[2]&.downcase
      id = line.split[1].delete("@")
      hash[key[0]] = {"id" => id}
    when 1..2
      key[idx] = line.split[1].downcase
      value = line.split.drop(2).join(" ")
      value = {} if value.empty?
      hash[key[0]][key[1]] = ((idx == 1) ? value : {})
      hash[key[0]][key[1]][key[2]] = value if idx == 2
    end
  end
  hash if hash.any?
end => new

print new.to_yaml
