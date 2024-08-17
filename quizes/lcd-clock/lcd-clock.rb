#!/usr/bin/env  ruby

require "tty-reader"

def quit?
  reader = TTY::Reader.new
  /q/i.match?(reader.read_keypress(nonblock: true))
end

def double_digit(value) = (value < 10) ? "0#{value}" : value.to_s

scale = (ARGV.include?("-s") ? ARGV[ARGV.index("-s") + 1].to_i : 1)

rows = {a: [4, 0, 4, 4, 0, 4, 4, 4, 4, 4],
        b: [2, 3, 3, 3, 2, 1, 1, 3, 2, 2],
        c: [0, 0, 4, 4, 4, 4, 4, 0, 4, 4],
        d: [2, 3, 1, 3, 3, 3, 2, 3, 2, 3],
        e: [4, 0, 4, 4, 0, 4, 4, 0, 4, 4]}

symbol_map = {0 => " " + " " * scale + " ",
              1 => "|" + " " * scale + " ",
              2 => "|" + " " * scale + "|",
              3 => " " + " " * scale + "|",
              4 => " " + "-" * scale + " "}

loop do
  system("clear")

  [:a, :b, :c, :d, :e].each do |row|
    ((row == :b || row == :d) ? scale.times : [1]).each do
      double_digit(Time.now.hour).each_char { |n| print symbol_map[rows[row][n.to_i]] + " " }
      print((row == :b || row == :d) ? ". " : "  ")
      double_digit(Time.now.min).each_char { |n| print symbol_map[rows[row][n.to_i]] + " " }
      print((row == :b || row == :d) ? ". " : "  ")
      double_digit(Time.now.sec).each_char { |n| print symbol_map[rows[row][n.to_i]] + " " }
      print "\n"
    end
  end
  break if quit?
  sleep 1
end
