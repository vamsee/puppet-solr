class solr::install {

  package { 'default-jdk':
    ensure  => 'present',
  }

  package { 'jetty':
    ensure  => 'present',
    require => Package['default-jdk'],
  }

  package { 'libjetty-extra':
    ensure  => 'present',
    require => Package['jetty'],
  }
}
