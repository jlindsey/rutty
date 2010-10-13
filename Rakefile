require 'rubygems'
require 'rake'

begin
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
    gem.authors = ["Josh Lindsey"]
    gem.add_development_dependency "bundler", ">= 1.0.0"
    gem.add_dependency "commander", ">= 4.0.3"
    gem.add_dependency "net-ssh", ">= 2.0.23"
    gem.add_dependency "net-scp", ">= 1.0.4"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
