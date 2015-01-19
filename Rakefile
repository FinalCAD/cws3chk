require "bundler/gem_tasks"

require "carrierwave_assets_presence_validator/tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
