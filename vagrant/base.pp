# the default path for puppet to look for executables
Exec { path => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin', '/usr/local/bin' ] }

stage { 'first': }

stage { 'last': }

Stage['first'] -> Stage['main'] -> Stage['last']

# lint:ignore:autoloader_layout
class base {
  exec {'apt-get update && touch /tmp/apt-get-updated':
    unless => 'test -e /tmp/apt-get-updated'
  }
}
# lint:endignore

# run apt-get update before anything else runs
class { 'base':
  stage => first,
}

# default use case
# include solr

# With all options
class { 'solr':
  mirror  => 'http://apache.bytenet.in/lucene/solr',
  version => '4.10.3',
  cores   => ['development', 'staging', 'production'],
}
