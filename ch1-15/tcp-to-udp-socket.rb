#!/usr/bin/env  ruby

require "socket"

server = TCPServer.new(nil, 1234)
socket = UDPSocket.new
socket.bind(nil, 1234)

while connection = server.accept
  while line = connection.gets
    puts line
    socket.send(line, 0, "127.0.0.1", 4444)
  end
end
