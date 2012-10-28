#!/usr/bin/env rake
require 'rake/testtask'
require 'foodcritic'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/unit/**/*_spec.rb']
  t.verbose = true
end

FoodCritic::Rake::LintTask.new do |t|
  t.options = { :fail_tags => ['any'] }
end

task :default => [:foodcritic, :test]
