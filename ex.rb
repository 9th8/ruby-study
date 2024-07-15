#!/usr/bin/env  ruby

# ["debug", "debug/open"].each { |m| require m if ENV["DEBUG"] }

class Person
  def add_accessor(accessor_name)
    Person.class_eval %(
      attr_accessor :#{accessor_name}
      ), __FILE__, __LINE__ - 2
  end
end

person = Person.new
person.add_accessor :name
person.add_accessor :gender
person.name = "Carleton DiLeo"
person.gender = "male"
puts "#{person.name} is #{person.gender}"
