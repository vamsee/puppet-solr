class solr::install {

  package { 'default-jdk':
    ensure => present,
  }
 
  package { 'solr-jetty':
    ensure => present,
    require => Package['default-jdk'],
  }

}
