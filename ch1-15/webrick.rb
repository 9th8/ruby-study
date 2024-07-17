#!/usr/bin/env  ruby

# ["debug", "debug/open"].each { |m| require m if ENV["DEBUG"] }

require "webrick"

class MyNormalClass
  def self.add(a, b)
    a.to_i + b.to_i
  end

  def self.subtract(a, b)
    a.to_i - b.to_i
  end
end

class MyServlet < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    if request.query["a"] && request.query["b"]
      a = request.query["a"]
      b = request.query["b"]
      response.status = 200
      response.content_type = "text/plain"

      result = case request.path
      when "/add"
        MyNormalClass.add(a, b)
      when "/subtract"
        MyNormalClass.subtract(a, b)
      else
        "No such method"
      end

      response.body = result.to_s + "\n"
    else
      response.status = 400
      response.body = "You did not provide the correct parameters"
    end
  end
end

server = WEBrick::HTTPServer.new(Port: 1234)
server.mount "/", MyServlet
trap("INT") { server.shutdown }
server.start
