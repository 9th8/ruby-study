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

  def get_info(choice)
    puts "#{name} is a #{choice}. #{gender ? "His" : "Her"} age is #{age} " \
      "and #{gender ? "his" : "her"} color is #{color}. #{name} says '#{says}'"
  end
end # }}}

class Cat < Pet; end # {{{

class Dog < Pet; end

class Bird < Pet
  def count(i)
    @says = (@says + " ") * (i - 1) + @says
  end
end # }}}

print "Choose: cat, dog or bird? "
choice = gets.chomp
case choice
when "cat"
  pet = Cat.new("Matroskin", 10, "m", "gray stripes", "Meow!")
when "dog"
  pet = Dog.new("Sharik", 10, "m", "brown", "Wow!")
  pet.says = "Dogs don't talk."
when "bird"
  pet = Bird.new("Khvataika", 2, "m", "gray", "Kto tam?")
  pet.count(3)
else
  puts "I know nothing of #{choice}."
  exit 1
end

pet.get_info(choice)
