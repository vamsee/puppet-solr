# the default path for puppet to look for executables
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

stage { 'first': }

stage { 'last': }

Stage['first'] -> Stage['main'] -> Stage['last']

class update_aptget {
  exec {'apt-get update && touch /tmp/apt-get-updated':
    unless => 'test -e /tmp/apt-get-updated'
  }
}

# run apt-get update before anything else runs
class {'update_aptget':
  stage => first,
}

# default use case
# include solr

# With all options
class { 'solr':
  mirror        => 'http://apache.mesi.com.ar/lucene/solr',
  version       => '4.7.2',
  cores         => ['development', 'staging', 'production'],
}
