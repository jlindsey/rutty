require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "rutty"
  gem.summary = %Q{A DSH implementation in Ruby}
  gem.description = %Q{
      RuTTY is a DSH (distributed / dancer's shell) written in Ruby. It's used to run commands 
      on multiple remote servers at once, based on a tagging system. Also allows for multiple
      SCP-style uploads.
    }
  gem.email = "josh@cloudspace.com"
  gem.homepage = "http://github.com/jlindsey/rutty"
  gem.license = "MIT"
  gem.authors = ["Josh Lindsey"]
  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_development_dependency "jeweler", ">= 1.5.1"
  gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
  gem.add_development_dependency "xml-simple", ">= 1.0.12"
  gem.add_runtime_dependency "commander", ">= 4.0.3"
  gem.add_runtime_dependency "terminal-table", ">= 1.4.2"
  gem.add_runtime_dependency "json", ">= 1.4.6"
  gem.add_runtime_dependency "net-ssh", ">= 2.0.23"
  gem.add_runtime_dependency "net-scp", ">= 1.0.4"
  gem.add_runtime_dependency "builder", ">= 2.1.2"
  gem.add_runtime_dependency "treetop", ">= 1.4.8"
  gem.add_runtime_dependency "fastthread", ">= 1.0.7"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = false
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true 
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :default => :test

