# == Class: solr::install
# This class installs the required packages for jetty
#
# === Actions
# - Installs default jdk
# - Installs jetty and extra libs
#

class solr::install {

  if ! defined(Package['default-jdk']) {
      package { 'default-jdk':
          ensure => present,
      }
  }

  if ! defined(Package['jetty']) {
      package { 'jetty':
          ensure => present,
          require => Package['default-jdk'],
      }
  }

  if ! defined(Package['libjetty-extra']) {
      package { 'libjetty-extra':
          ensure => present,
          require => Package['jetty'],
      }
  }

  if ! defined(Package['wget']) {
      package { 'wget':
          ensure => present,
      }
  }

  if ! defined(Package['curl']) {
      package { 'curl':
          ensure => present,
      }
  }

}

