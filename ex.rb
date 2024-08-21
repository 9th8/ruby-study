#!/usr/bin/env  ruby
require " drb"
F = File
def c(u)
  DRbObject.new((), u)
end

def x(u)
  [P, u].hash
end

def s(p)
  F.basename p[/[^|]+/]
end

P, M, U, V, *O = $*

if M["s"]
  DRb.start_service V, Class.new {
    def p(z = O)
      O.push(*z).uniq
    end
    new.methods.map { |m| m[/_[_t]/] || private(m) }
    def y
      (p(U) + p).map { |u| u != U && c(u).f(x(u), p(U)) }
      self
    end

    def f(c, a = O, t = 2)
      if x(U) == c && t < 1
        Dir[s(a)]
      else
        (t < 2) ? [*open(s(a), "rb")] : p(a)
      end
    end
  }.new.y
  sleep
else
  c(U).f(x(U)).map { |n| c(n).f(x(n), V, 0).map { |f| s f }.map { |f| O[0] ? p(f) : open(f, "wb") << c(n).f(x(n), f, 1) } }
end
