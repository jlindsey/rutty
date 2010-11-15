RuTTY
=====

RuTTY is a DSH implementation in Ruby. You can use it to execute shell commands on multiple remote
servers simultaneously using a tagging system to target just the servers you want.

Also supports SCP uploads to multiple remote servers using the same tagging system.

Requirements
------------

* Ruby >= 1.8.7 (Not tested on 1.9.x)
* Rubygems >= 1.3.7

###Development Requirements###

* Bundler >= 1.0.0

Installation
------------

	$ sudo gem install rutty
	$ rutty init
	$ rutty help

Usage
-----

###Init###

You must first initialize the RuTTY configuration and data directory with the `rutty init` command. This
command takes an optional argument to specify the directory to install into. If omitted, it will install
into `~/.rutty/`. Note that if you install into a directory other than the default, you will have to supply
the config to all the other commands with the `-c` option.

	$ rutty init
	         create  /Users/jlindsey/.rutty
	         create  /Users/jlindsey/.rutty/defaults.yaml
	         create  /Users/jlindsey/.rutty/nodes.yaml
	

###Adding Nodes###

After initialization, you must add nodes to the RuTTY config. This is done with the `rutty add_node` command.
Invoking `rutty help add_node` will give you a list of all the options to pass into it. Any options you don't pass
will be filled in from the defaults at `$RUTTY_HOME/defaults.yaml`.

	$ rutty add_node example.com -u root -k /Users/jlindsey/.ssh/id_rsa --tags example,test
	
The above will add a node to the RuTTY config that looks like this (in YAML):

	---
	host: example.com
	user: root
	keypath: /Users/jlindsey/.ssh/id_rsa
	tags:
		- example
		- test
	port: 22
	
Note that the `port: 22` line was filled in from the defaults because it was not specified.

###Running Commands###

Now that we have a node, we can run commands on it. The default RuTTY command is the `dsh` action, so it
can be omitted. That is to say, the following two commands are identical:

	$ rutty dsh -a uptime
	$ rutty -a uptime

The `dsh` action can accept either a list of tags passed via `--tags` or the `-a` flag, which will run the command
on all defined nodes regardless of tags.

Note that any command that has any whitespace in it must be enclosed in quotes.

	$ rutty -a "free -m"
	
###Tags###

The `rutty dsh` and `rutty scp` commands both allow the `--tags` flag. The usage of this flag on these two commands
is different than on `add_node`, where it is simply a list of tags to apply to the new node. On the remote commands,
it essentially has three "modes": single tag, multiple comma-separated tags, and pseudo-SQL tag query.

The single tag mode is simple. The command

	$ rutty dsh --tags foobar uptime

will run the `uptime` command on every node that is tagged with "foobar".

---

The multiple tags mode is essentially an OR query. It will run the command on any nodes that have **ANY** of the
specified tags. For example:

	$ rutty dsh --tags foo,baz,bar uptime

will run the `uptime` command on any nodes that are tagged with "foo" **OR** "baz" **OR** "bar".

---

The pseudo-SQL tag query mode provides the most control over your tags. This allows you to pass in a string that looks
a bit like SQL, letting you specify complex rules for your tag lookup. For example:

	$ rutty dsh --tags "'foo' AND 'bar'" uptime

will run `uptime` on any node that has **BOTH** "foo" and "bar" tags. The command

	$ rutty dsh --tags "'foo' OR ('baz' AND 'bar')" uptime
	
will run `uptime` on any node that has a "foo" tag **OR** any node that has **BOTH** "baz" and "bar" tags.

TODO
----

* Cleanup dsh action code
* Implement delete_node command

Copyright
---------

Copyright (c) 2010 Josh Lindsey at Cloudspace. See LICENSE for details.