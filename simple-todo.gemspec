# -*- encoding: utf-8 -*-
require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Graeme Nelson"]
  gem.email         = ["graeme.nelson@gmail.com"]
  gem.description   = %q{Simple todo library, to show off the Entity - Boundries - Interactor architecture}
  gem.summary       = %q{Simple todo library, to show off the Entity - Boundries - Interactor architecture}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "simple-todo"
  gem.require_paths = ["lib"]
  gem.version       = SimpleTodo::VERSION

  gem.add_dependency "bcrypt-ruby"
  
end