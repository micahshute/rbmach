require "bundler/gem_tasks"
require "rspec/core/rake_task"
require_relative './lib/rbmach'

spec = Gem::Specification.find_by_name 'gspec'
load "#{spec.gem_dir}/lib/gspec/tasks/generator.rake"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Console"
task :console do 
    Pry.start
end

