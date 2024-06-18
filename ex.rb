#!/usr/bin/env  ruby

class Person # {{{
  attr_accessor :name, :age, :gender
end # }}}

class Pet # {{{
  attr_accessor :name, :age, :gender, :color, :says
  def initialize(name, age, gender, color, says)
    @name = name
    @age = age
    @gender = true if gender == "m"
    @color = color
    @says = says
  end
end # }}}

class Cat < Pet; end # {{{

class Dog < Pet; end

class Bird < Pet
  def count(i)
    @says = (@says + " ") * (i - 1) + @says
  end
end # }}}

cat = Cat.new("Matroskin", 10, "m", "gray stripes", "Meow!")
dog = Dog.new("Sharik", 10, "m", "brown", "Wow!")
bird = Bird.new("Khvataika", 2, "m", "gray", "Kto tam?")

dog.says = "Dogs don't talk."
bird.count(3)

[cat, dog, bird].each do |pet|
  puts "#{pet.name} is a #{pet.class}. #{pet.gender ? "His" : "Her"} age is #{pet.age} " \
  "and #{pet.gender ? "his" : "her"} color is #{pet.color}. #{pet.name} says '#{pet.says}'"
end
