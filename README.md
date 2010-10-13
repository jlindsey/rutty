RuTTY
=====

RuTTY is a DSH implementation in Ruby.

Requirements
------------

* Ruby >= 1.8.7 (Not tested on 1.9.x)
* Rubygems >= 1.3.7
* Bundler >= 1.0.0

Installation
------------

	$ sudo gem install bundler
	$ git clone git://github.com/jlindsey/rutty.git
	$ cd rutty
	$ bundle install
	$ ./rutty --help

TODO
----

* Cleanup dsh action code
* Expand the tag searching semantics to allow for AND and/or OR queries
* Add a special printout for > 0 exit codes on dsh action
* Implement delete_node command
* Make better printouts
* Documentation
* Tests

Copyright
---------

Copyright (c) 2010 Josh Lindsey at Cloudspace. See LICENSE for details.