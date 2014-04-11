require "bundler/gem_tasks"
 
require 'rake/testtask'
 
Rake::TestTask.new do |t|
  t.libs << 'lib/jumio_rock'
  t.test_files = FileList['test/lib/jumio_rock/*_test.rb']
  t.verbose = true
end
 
task :default => :test

