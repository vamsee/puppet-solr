# Solr Module

This is a puppet module for setting up a multi-core solr instance. 

#Quick Start

Put this in your solr.pp file and run sudo puppet apply:

  class { solr:
    cores => [ 'development', 'staging', 'production' ]
  }

*NOTE*: Currently only Ubuntu is supported, contributions for other platforms are most welcome. 
The code is well commented, and should give you a clear idea about how this module 
configures solr. Please read those for more information.

#TODO

 * Support other platforms
 * Provide a proper test suite

#License

MIT. Please see the LICENSE file for more information.

#Contact

Contributions, especially making this multiplatform are most welcome. Write to me at vkanakala AT gmail D0T com.

#Support

Please log tickets and issues in the issues page (https://github.com/vamsee/puppet-solr/issues)
