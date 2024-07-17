#!/usr/bin/env  ruby

require "socket"

server = TCPServer.new(nil, 1234)

loop do
  Thread.start(server.accept) do |connection|
    while (line = connection.gets)
      puts line
      connection.puts "Received '#{line.chomp}'"
    end
  end
end
