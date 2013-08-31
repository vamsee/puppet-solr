class solr::config {

  #Copy the jetty config file
  file { 'jetty-default':
    ensure  => file,
    path    => '/etc/default/jetty',
    source  => 'puppet:///modules/solr/jetty-default',
    # notify  => Service['jetty'],
    require => Package['jetty'],
  }

  file { 'solr':
    ensure    => 'directory',
    owner     => 'root',
    group     => 'root',
    recurse   => 'true',
    path      => '/usr/share/solr',
    source    => 'puppet:///modules/solr/solr',
  }

}

