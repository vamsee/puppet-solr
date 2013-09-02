class solr::config {

  #Copy the jetty config file
  file { 'jetty-default':
    ensure  => 'file',
    path    => '/etc/default/jetty',
    source  => 'puppet:///modules/solr/jetty-default',
    # notify  => Service['jetty'],
    require => 'Package[jetty]',
  }

  file { 'solr':
    ensure    => 'directory',
    owner     => 'jetty',
    group     => 'jetty',
    recurse   => 'true',
    path      => '/usr/share/solr',
    source    => 'puppet:///modules/solr/solr',
  }

  file { 'solr-data':
    ensure    => 'directory',
    owner     => 'jetty',
    group     => 'jetty',
    mode      => '0700',
    path      => '/var/lib/solr',
    require   => 'Package[jetty]',
  }

}

