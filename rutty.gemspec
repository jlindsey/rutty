# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rutty}
  s.version = "2.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Lindsey"]
  s.date = %q{2010-11-27}
  s.default_executable = %q{rutty}
  s.description = %q{
      RuTTY is a DSH (distributed / dancer's shell) written in Ruby. It's used to run commands 
      on multiple remote servers at once, based on a tagging system. Also allows for multiple
      SCP-style uploads.
    }
  s.email = %q{josh@cloudspace.com}
  s.executables = ["rutty"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    ".yardopts",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/rutty",
    "lib/rutty.rb",
    "lib/rutty/actions.rb",
    "lib/rutty/config.rb",
    "lib/rutty/consts.rb",
    "lib/rutty/errors.rb",
    "lib/rutty/helpers.rb",
    "lib/rutty/node.rb",
    "lib/rutty/nodes.rb",
    "lib/rutty/proc_classes.rb",
    "lib/rutty/thread_pool/pool.rb",
    "lib/rutty/thread_pool/worker.rb",
    "lib/rutty/treetop/syntax_nodes.rb",
    "lib/rutty/treetop/tag_query.rb",
    "lib/rutty/treetop/tag_query.treetop",
    "lib/rutty/version.rb",
    "rutty.gemspec",
    "test/helper.rb",
    "test/test_action_add_node.rb",
    "test/test_action_dsh.rb",
    "test/test_action_init.rb",
    "test/test_action_list_nodes.rb",
    "test/test_action_scp.rb",
    "test/test_actions.rb",
    "test/test_config.rb",
    "test/test_consts.rb",
    "test/test_helpers.rb",
    "test/test_node.rb",
    "test/test_nodes.rb",
    "test/test_runner.rb"
  ]
  s.homepage = %q{http://github.com/jlindsey/rutty}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A DSH implementation in Ruby}
  s.test_files = [
    "test/helper.rb",
    "test/test_action_add_node.rb",
    "test/test_action_dsh.rb",
    "test/test_action_init.rb",
    "test/test_action_list_nodes.rb",
    "test/test_action_scp.rb",
    "test/test_actions.rb",
    "test/test_config.rb",
    "test/test_consts.rb",
    "test/test_helpers.rb",
    "test/test_node.rb",
    "test/test_nodes.rb",
    "test/test_runner.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<commander>, ["~> 4.0.3"])
      s.add_runtime_dependency(%q<terminal-table>, ["~> 1.4.2"])
      s.add_runtime_dependency(%q<json>, ["~> 1.4.6"])
      s.add_runtime_dependency(%q<net-ssh>, ["~> 2.0.23"])
      s.add_runtime_dependency(%q<net-scp>, ["~> 1.0.4"])
      s.add_runtime_dependency(%q<builder>, ["~> 2.1.2"])
      s.add_runtime_dependency(%q<treetop>, ["~> 1.4.8"])
      s.add_runtime_dependency(%q<fastthread>, ["~> 1.0.7"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<xml-simple>, ["~> 1.0.12"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
    else
      s.add_dependency(%q<commander>, ["~> 4.0.3"])
      s.add_dependency(%q<terminal-table>, ["~> 1.4.2"])
      s.add_dependency(%q<json>, ["~> 1.4.6"])
      s.add_dependency(%q<net-ssh>, ["~> 2.0.23"])
      s.add_dependency(%q<net-scp>, ["~> 1.0.4"])
      s.add_dependency(%q<builder>, ["~> 2.1.2"])
      s.add_dependency(%q<treetop>, ["~> 1.4.8"])
      s.add_dependency(%q<fastthread>, ["~> 1.0.7"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<xml-simple>, ["~> 1.0.12"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
    end
  else
    s.add_dependency(%q<commander>, ["~> 4.0.3"])
    s.add_dependency(%q<terminal-table>, ["~> 1.4.2"])
    s.add_dependency(%q<json>, ["~> 1.4.6"])
    s.add_dependency(%q<net-ssh>, ["~> 2.0.23"])
    s.add_dependency(%q<net-scp>, ["~> 1.0.4"])
    s.add_dependency(%q<builder>, ["~> 2.1.2"])
    s.add_dependency(%q<treetop>, ["~> 1.4.8"])
    s.add_dependency(%q<fastthread>, ["~> 1.0.7"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<xml-simple>, ["~> 1.0.12"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
  end
end

