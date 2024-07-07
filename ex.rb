#!/usr/bin/env  ruby

["debug", "debug/open"].each { |m| require m if ENV["DEBUG"] }
["debug", "dotenv"].each { |m| require m }
# Dotenv.load(".env")

class String
  def titleize
    gsub(/(\A|\s)\w/) { |letter| letter.upcase }
  end
end

raise "Fail 1" unless "this is a test".titleize == "This Is A Test"
raise "Fail 2" unless "another test 1234".titleize == "Another Test 1234"
raise "Fail 3" unless "We're testing titleize".titleize == "We're Testing Titleize"
