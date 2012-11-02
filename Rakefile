require 'bundler/gem_tasks'
require 'rake/testtask'

desc "Jump into the console"
task :console do
  system "irb -I . -I lib -r lib/simple-todo.rb"
end

desc "Run unit tests"
Rake::TestTask.new( "test:unit" ) { |t|
  t.libs    << '.'
  t.pattern = 'spec/unit/**/*_spec.rb'
  t.verbose = false
  t.warning = false
}

desc "Run integration tests"
Rake::TestTask.new( "test:integration" ) { |t| 
  t.libs    << '.'
  t.pattern = 'spec/integration/**/*_spec.rb'
  t.verbose = false
  t.warning = false
}

desc "Runs all the tests"
task "test:all" => ["test:unit", "test:integration"]

desc "Runs just the unit tests by default"
task :default => "test:unit"