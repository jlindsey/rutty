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

  require './lib/rutty/version.rb'
  gem.version = Rutty::Version::STRING
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = false
end

task :default => :test

namespace :treetop do
  desc "Recompile the Treetop Ruby parser file"
  task :regen do
    puts %x(cd #{File.dirname __FILE__}/lib/rutty/treetop && tt tag_query.treetop 2>&1)
  end
end

