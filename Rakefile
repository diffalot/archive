require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rcov/rcovtask'
require 'spec/rake/spectask'

namespace :gem do
  task :jeweler do
    begin
      require 'jeweler'
      Jeweler::Tasks.new do |s|
        s.name        = "archive.org"
        s.summary     = %Q{TODO}
        s.email       = "papyromancer@papyromancer.com"
        s.homepage    = "http://github.com/papyromancer/archive"
        s.description = "TODO"
        s.authors     = ["papyromancer"]
      end
    rescue LoadError
      puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
    end
  end
end

Rake::TestTask.new do |t|
  t.libs        << 'lib'
  t.pattern     = 'test/**/*_test.rb'
  t.verbose     = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'archive'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rcov::RcovTask.new do |t|
  t.libs        << 'test'
  t.test_files  = FileList['test/**/*_test.rb']
  t.verbose     = true
end

desc "Run all examples"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

task :default => :rcov
