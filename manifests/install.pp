# == Class: solr::install
# This class installs the required packages for jetty
#
# === Actions
# - Installs default jdk
# - Installs jetty and extra libs
#
class solr::install {

  package { 'default-jdk':
    ensure  => present,
  }

  package { 'jetty':
    ensure  => present,
    require => Package['default-jdk'],
  }

  package { 'libjetty-extra':
    ensure  => present,
    require => Package['jetty'],
  }

  package { 'wget':
    ensure  => present,
  }

  package { 'curl':
    ensure  => present,
  }
}

