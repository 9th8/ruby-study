#!/usr/bin/env  ruby

["debug", "debug/open"].each { |m| require m if ENV["DEBUG"] }

require "yaml"

read_data = YAML.load_file("ppl.yaml")

puts read_data
