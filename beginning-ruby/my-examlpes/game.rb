#! /usr/bin/env ruby
class Player
  attr_accessor :name, :health, :attack

  def initialize(name)
    @name = name
    @health = 100
    @attack = 10
  end

  def take_damage(damage)
    @health -= damage
  end

  def attack(enemy)
    enemy.take_damage(@attack)
  end
end

class Enemy
  attr_accessor :name, :health, :attack

  def initialize(name)
    @name = name
    @health = 50
    @attack = 5
  end

  def take_damage(damage)
    @health -= damage
  end

  def attack(player)
    player.take_damage(@attack)
  end
end

player = Player.new("Игрок1")
enemy = Enemy.new("Гоблин")

puts "Добро пожаловать в игру-лабиринт!"
puts "Игрок: #{player.name} - Здоровье: #{player.health}"
puts "Враг: #{enemy.name} - Здоровье: #{enemy.health}"

while player.health > 0 && enemy.health > 0
  player.attack(enemy)
  puts "#{player.name} атакует #{enemy.name} и наносит #{player.attack} урона."
  puts "Здоровье #{enemy.name}: #{enemy.health}"

  if enemy.health <= 0
    puts "#{enemy.name} был побежден!"
    break
  end

  enemy.attack(player)
  puts "#{enemy.name} атакует #{player.name} и наносит #{enemy.attack} урона."
  puts "Здоровье #{player.name}: #{player.health}"

  if player.health <= 0
    puts "#{player.name} был побежден!"
    break
  end
end
