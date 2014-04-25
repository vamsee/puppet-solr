# Solr Module  

[![Build Status](https://travis-ci.org/vamsee/puppet-solr.png)](https://travis-ci.org/vamsee/puppet-solr)

This is a puppet module for setting up a multi-core solr instance.

## Quick Start

Put this in your site.pp file and run sudo puppet apply:

    include solr

If you need multiple cores out of the box, you can run this:

    class { solr:
      cores => [ 'development', 'staging', 'production' ]
    }

It's _**highly**_ recommended that you use a mirror like so:

    class { 'solr':
      mirror        => 'http://apache.mesi.com.ar/lucene/solr',
      version       => '4.7.2',
      cores         => ['development', 'staging', 'production'],
    }

**NOTE**: Currently only Ubuntu is supported, contributions for other platforms are most welcome.
The code is well commented, and should give you a clear idea about how this module configures solr.

## Running the tests

The module is developed through Vagrant (http://www.vagrantup.com) for easy testability. You can also
use this to quickly test the module for yourself. Just cd into the directory and run:

    vagrant up

The solr server maps to port 8080 by default, and vagrant maps this to port 8080 on host system also.
So you should be able to see the solr server running at http://0.0.0.0:8080/solr. This module also has
a good test suite, you can run the specs by simply typing:

    rake

If you want to run the system specs (slower, uses vagrant with serverspec) you can do the following:

    rake spec:system

If you want to run them all together, use this:

    rake spec:all

## TODO

 * Support other platforms

##License

MIT. Please see the LICENSE file for more information.

## Contact

Contributions, especially making this multiplatform are most welcome.

## Support

Please log tickets and issues in the issues page (https://github.com/vamsee/puppet-solr/issues)
