#!/usr/bin/env  ruby

# ["debug", "debug/open"].each { |m| require m if ENV["DEBUG"] }

require "net/ping"
require "resolv"

if system("ping -c1 lb.jupiter-mbr.renv-0005.rancher-test.homecredit.ru 2>/dev/null 1>&2")
  puts "Pong!"
else
  puts "Unreachable.."
end

Resolv::DNS.open do |dns|
  dns.getresources("lb.jupiter-mbr.renv-0005.rancher-test.homecredit.ru", Resolv::DNS::Resource::IN::A).each do |i|
    p i.ttl
  end
end

def port_available_tcp?(port)
  Net::Ping::TCP.new("rancher.homecredit.ru", port).ping
end

port = 443 # Change this to the port you want to check
if port_available_tcp?(port)
  puts "Port #{port} is available for TCP connections."
else
  puts "Port #{port} is not available for TCP connections."
end
