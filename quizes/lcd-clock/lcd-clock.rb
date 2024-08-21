#!/usr/bin/env  ruby
require "io/console"
require "optparse"

class ClockDisplay
  def initialize
    @scale = 1
    @offset_h = (IO.console.winsize.last - 6 * @scale - 21) / 2
    @offset_v = (IO.console.winsize.first - 2 * @scale - 3) / 2
    parse_options
    hide_cursor
    at_exit { restore_terminal }
  end

  def parse_options
    parser = OptionParser.new do |opts|
      opts.on("-h", "--help", "Displays this message.") do
        puts opts
        exit
      end
      opts.on("-s", "--scale N", Integer, "Sets display scale factor to N.") do |n|
        @scale = n
      end
      opts.banner = "Usage: #{File.basename($PROGRAM_NAME)} [-s | --scale N]"
    end

    begin
      parser.parse!
    rescue OptionParser::ParseError => e
      puts e.message
      puts parser
      exit 1
    end
  end

  def hide_cursor
    print "\e[?25l\e[1m"  # прячем курсор и включаем болд.
  end

  def restore_terminal
    print "\e[?25h\e[0m\e[3J"  # возвращаем курсор, сбрасываем болд и очищаем буфер прокрутки.
  end

  def double_digit(value)
    (value < 10) ? "0#{value}" : value.to_s
  end

  def symbol_map
    {
      0 => " " + " " * @scale + " ",
      1 => "|" + " " * @scale + " ",
      2 => "|" + " " * @scale + "|",
      3 => " " + " " * @scale + "|",
      4 => " " + "-" * @scale + " "
    }
  end

  def rows
    {
      a: [4, 0, 4, 4, 0, 4, 4, 4, 4, 4],
      b: [2, 3, 3, 3, 2, 1, 1, 3, 2, 2],
      c: [0, 0, 4, 4, 4, 4, 4, 0, 4, 4],
      d: [2, 3, 1, 3, 3, 3, 2, 3, 2, 3],
      e: [4, 0, 4, 4, 0, 4, 4, 0, 4, 4]
    }
  end

  def quit?
    system("/bin/stty raw -echo")
    begin
      char = $stdin.read_nonblock(1)
    rescue
      nil
    end
    system("/bin/stty -raw echo")
    /q/i.match?(char)
  end

  def run
    loop do
      print "\e[2J\e[#{@offset_v};1H"  # очищаем экран и перемещаем курсор в колонку offset_v.
      [:a, :b, :c, :d, :e].each do |row|
        ((row == :b || row == :d) ? @scale.times : [1]).each do
          print "\e[#{@offset_h}G"
          double_digit(Time.now.hour).each_char { |n| print symbol_map[rows[row][n.to_i]] + " " }
          print((row == :b || row == :d) ? ". " : "  ")
          double_digit(Time.now.min).each_char { |n| print symbol_map[rows[row][n.to_i]] + " " }
          print((row == :b || row == :d) ? ". " : "  ")
          double_digit(Time.now.sec).each_char { |n| print symbol_map[rows[row][n.to_i]] + " " }
          print "\n"
        end
      end
      exit if quit?
      sleep 0.05
    end
  end
end

clock_display = ClockDisplay.new
clock_display.run
