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

	$ git clone git://github.com/jlindsey/rutty.git
	$ cd rutty
	$ bundle install
	$ ./rutty --help

TODO
----

* Replace the ugly and problematic %x{} ssh calls with Net::SSH
* Implement scp command using Net::SCP
* Implement delete_node command
* Make better printouts

Copyright
---------

Copyright (c) 2010 Josh Lindsey at Cloudspace. See LICENSE for details.