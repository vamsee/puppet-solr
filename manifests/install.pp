class solr::install {

  package { 'default-jdk':
    ensure => present,
  }
 
  package { 'solr-jetty':
    ensure => present,
    require => Package['default-jdk'],
  }

  #Copy the jetty config file
  file { 'jetty-default':
    ensure => file,
    path => "/etc/default/jetty",
    source => "puppet:///modules/solr/jetty-default",
    notify => Service['jetty'],
    require => Package['solr-jetty'],
  }

}
