#!/usr/bin/env  ruby

# ["debug", "debug/open"].each { |m| require m if ENV["DEBUG"] }

require "sequel"

db = Sequel.sqlite("temp.db")

unless db.table_exists?(:people)
  db.create_table :people do
    primary_key :id
    String :first_name
    String :last_name
    Integer :age
  end
end

people = db[:people]
people.insert(first_name: "Fred", last_name: "Bloggs", age: 32)

puts "There are #{people.count} people in the database"

people.each do |person|
  puts person[:first_name]
end

db.fetch("SELECT * FROM people") do |row|
  puts row[:first_name]
end
