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
    exec { 'install-java8-for-solr':
      command => "add-apt-repository -y ppa:webupd8team/java; apt-get -y update; echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections; apt-get -y install oracle-java8-installer",
      require => Package['python-software-properties', 'software-properties-common'],
      creates => "/usr/lib/jvm/java-8-oracle"
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

