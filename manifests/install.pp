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
        ensure    => present,
      }
  }

  if versioncmp($::solr::version, '5.0') < 0 {

    if ! defined(Package['jetty']) {
        package { 'jetty':
            ensure  => present,
            require => Package['default-jdk'],
        }
    }

    if ! defined(Package['libjetty-extra']) {
        package { 'libjetty-extra':
            ensure  => present,
            require => Package['jetty'],
        }
    }

  } else {
    include java
    java::oracle { 'jdk8' :
        ensure  => 'present',
        version => '8',
        java_se => 'jdk',
    }
  }

  if ! defined(Package['wget']) {
      package { 'wget':
          ensure  => present,
      }
  }

  if ! defined(Package['curl']) {
      package { 'curl':
          ensure  => present,
      }
  }

}

