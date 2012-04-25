#!/usr/bin/env rake
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['test/**/*_spec.rb']
  t.verbose = true
end

desc "Runs foodcritc linter"
task :foodcritic do
  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    sandbox = File.join(File.dirname(__FILE__), %w{tmp foodcritic cookbook})
    prepare_foodcritic_sandbox(sandbox)

    sh "foodcritic --epic-fail any #{File.dirname(sandbox)}"
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

task :default => 'test'

private

def prepare_foodcritic_sandbox(sandbox)
  files = %w{*.md *.rb attributes definitions files providers
    recipes resources templates}

  rm_rf sandbox
  mkdir_p sandbox
  cp_r Dir.glob("{#{files.join(',')}}"), sandbox
end
