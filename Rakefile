#!/usr/bin/env rake
require 'rake/testtask'
require 'foodcritic'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/unit/**/*_spec.rb']
  t.verbose = true
end

FoodCritic::Rake::LintTask.new do |t|
  t.options = { :tags => ['~FC048'], :fail_tags => ['any'] }
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts ">>>>> Kitchen gem not loaded, omitting tasks" unless ENV['CI']
end

task :default => [:foodcritic, :test]
