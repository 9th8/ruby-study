#!/usr/bin/env  ruby

["pp"].each { |m| require m }

class TestClass
  def initialize(count)
    @@a = defined?(@@a) ? @@a + 1 : 0
    @c = @@a
    @d = [a: {b: count}, c: :d] * count
  end
end

pp TestClass.new(2), STDOUT, 120
pp TestClass.new(3), $>, 120
pp TestClass.new(4), $>, 120
