#!/usr/bin/env  ruby

# ["debug", "debug/open"].each { |m| require m if ENV["DEBUG"] }

require "socket"

s = UDPSocket.new
s.bind(nil, 1234)

5.times do
  s.send("line\n", 0, "127.0.0.1", 4444)
end
