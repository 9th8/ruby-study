#!/usr/bin/env  ruby

def each_glasny
  %w[a e i o u].each { |glasny| yield (glasny) }
end

hqbq = proc { |i| puts i }

%w[a e i o u].each { |glasny| hqbq.call(glasny) }
