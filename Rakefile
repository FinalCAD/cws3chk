require "bundler/gem_tasks"

require "Cws3chk/tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
