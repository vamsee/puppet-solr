class solr::config {

  #Copy the jetty config file
  file { 'jetty-default':
    ensure  => file,
    path    => '/etc/default/jetty',
    source  => 'puppet:///modules/solr/jetty-default',
    # notify  => Service['jetty'],
    require => Package['solr-jetty'],
  }

}

