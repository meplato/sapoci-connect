# Rakefile for SAPOCI Connect. -*-ruby-*
require 'rake/testtask'

desc "Run all tests"
task :default => [:test]

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/sapoci/connect.rb"
end

desc "Start server for tests"
task :start_test_server do
  sh "ruby test/live_server.rb"
end

