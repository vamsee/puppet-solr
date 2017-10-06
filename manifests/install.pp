# == Class: solr::install
# This class installs the required packages for jetty
#
# === Actions
# - Installs default jdk
# - Installs jetty and extra libs
#

class solr::install {

  ensure_packages(['python-software-properties', 'software-properties-common'])

  if versioncmp($::solr::version, '5.0') < 0 {
    case $::lsbdistcodename {

      'trusty': {
        if ! defined(Package['default-jdk']) {
          package { 'default-jdk':
          ensure    => present,
          }
        }

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
      }

      'xenial': {
        exec { 'Add_OpenJDK7_Repo':
          command => 'add-apt-repository -y ppa:openjdk-r/ppa; apt-get -y update',
          creates => '/etc/apt/sources.list.d/openjdk-r-ubuntu-ppa-xenial.list',
        }

        if ! defined(Package['openjdk-7-jre-headless']) {
          package { 'openjdk-7-jre-headless':
            ensure  => present,
            require => Exec['Add_OpenJDK7_Repo'],
          }
        }

        if ! defined(Package['jetty8']) {
          package { 'jetty8':
            ensure  => present,
            require => Package['openjdk-7-jre-headless'],
          }
        }

        if ! defined(Package['libjetty8-extra-java']) {
          package { 'libjetty8-extra-java':
            ensure  => present,
            require => Package['openjdk-7-jre-headless'],
          }
        }

        file { '/etc/init.d/jetty8':
          ensure  => present,
          group   => root,
          owner   => root,
          mode    => '0755',
          replace => yes,
          source  => 'puppet:///modules/solr/jetty8',
          require => Package['jetty8'],
      }
      default: { }
    }
  } else {
    exec { 'install-java8-for-solr':
      command => 'add-apt-repository -y ppa:webupd8team/java;\
apt-get -y update;\
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true |\
/usr/bin/debconf-set-selections; apt-get -y install oracle-java8-installer',
      require => Package['python-software-properties', 'software-properties-common'],
      timeout => 900,
      creates => '/usr/lib/jvm/java-8-oracle'
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
