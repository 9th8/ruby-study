#!/usr/bin/env  ruby

# ["debug", "debug/open"].each { |m| require m if ENV["DEBUG"] }

require "sinatra"
set :port, 8080

get "/time" do
  Time.now.to_s
end

get "/add" do
  a = params["a"]
  b = params["b"]
  (a.to_i + b.to_i).to_s
end

get "/app" do
  status 200
  content_type :json
  params.to_json
end
