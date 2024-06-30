#!/usr/bin/env  ruby

class Square
  # attr_writer :side_length
  def initialize(side_length) = @side_length = side_length

  def area = @side_length**2
end

a = Square.new(5)
b = Square.new(10)

puts a.area, b.area
