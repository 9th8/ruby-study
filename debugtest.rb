#! /usr/bin/env ruby

require "debug"
require "debug/open"

class Book
  attr_accessor :title, :author, :price

  def initialize(title, author, price)
    @title = title
    @author = author
    @price = price
  end
end

class BookStore
  def initialize
    @books = []
  end

  def add_book(book)
    @books << book
  end

  def remove_book(title)
    @books.delete_if { |book| book.title == title }
  end

  def find_by_title(title)
    @books.find { |book| book.title.include?(title) }
  end
end

# Sample Usage:
store = BookStore.new
book1 = Book.new("Dune", "Frank Herbert", 20.0)
book2 = Book.new("The Hobbit", "J.R.R. Tolkien", 15.0)
book3 = Book.new("Hobbit's Journey", "Unknown", 10.0)

store.add_book(book1)
store.add_book(book2)
store.add_book(book3)

puts store.find_by_title("Hobbit").title
