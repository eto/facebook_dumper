require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :run do
  sh "ruby bin/facebook_dumper ~/dev/200711/*.html"
end
