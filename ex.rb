#!/usr/bin/env  ruby

class Animal
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

class Cat < Animal
  def talk
    "Meow!"
  end
end

class Dog < Animal
  def talk
    "Woof!"
  end
end

animals = {Flossie: Cat, Clive: Dog, Max: Cat}
animals.each { |name, type| puts "#{name} - #{type.new(name).talk}" }
