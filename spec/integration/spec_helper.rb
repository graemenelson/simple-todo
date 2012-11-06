require 'rubygems'
require 'ostruct'
require 'minitest/autorun'

require './lib/simple-todo'
require './lib/repository/in_memory'

SimpleTodo::Repository.configuration({ person: SimpleTodo::Repository::InMemory::PersonRepository.new })
