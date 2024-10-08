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
    catch_q
    at_exit { restore_terminal }
  end

  def parse_options
    parser = OptionParser.new do |opts|
      opts.banner = "Displays current time with variable size font.\n\n" \
        "Usage: #{File.basename($PROGRAM_NAME)} [OPTIONS]\n\n" \
        "Options:\n"
      opts.on("-h", "--help", "Displays this message.") do
        puts opts
        exit
      end
      opts.on("-s", "--scale N", Integer, "Sets font scale factor to N.") do |n|
        @scale = n
      end
      opts.separator ""
      opts.separator "Example: #{File.basename($PROGRAM_NAME)} --scale 2"
    end

    begin
      parser.parse!
    rescue OptionParser::ParseError => e
      puts e.message
      puts parser
      exit 1
    end
  end

  # Прячем курсор и включаем болд.
  def hide_cursor = print "\e[?25l\e[1m"

  # Очищаем экран, возвращаем курсор в левый верхний угол и делаем видимым, сбрасываем болд.
  def restore_terminal = print "\e[2J\e[H\e[?25h\e[0m"

  def double_digit(value) = (value < 10) ? "0#{value}" : value.to_s

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

  def catch_q
    Thread.new do
      loop do
        sleep 0.1
        exit if quit?
      end
    end
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
      sleep 0.1
    end
  end
end

clock_display = ClockDisplay.new
clock_display.run
