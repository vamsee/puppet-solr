# == Class: solr::config
# This class sets up solr install
#
# === Parameters
# - The $cores to create
#
# === Actions
# - Copies a new jetty default file
# - Creates solr home directory
# - Creates solr data directory
# - Creates solr config file with cores specified
# - Links solr home directory to jetty webapps directory
#
class solr::config($cores) {
  include solr::params

  $jetty_home = $::solr::params::jetty_home
  $solr_home  = $solr::params::solr_home

  #Copy the jetty config file
  file { '/etc/default/jetty':
    ensure  => file,
    source  => 'puppet:///modules/solr/jetty-default',
    require => Package['jetty'],
  }

  file { $solr_home:
    ensure    => directory,
    owner     => 'jetty',
    group     => 'jetty',
    recurse   => true,
    source    => 'puppet:///modules/solr/solr',
  }

  file { '/var/lib/solr':
    ensure    => directory,
    owner     => 'jetty',
    group     => 'jetty',
    mode      => '0700',
    require   => Package['jetty'],
  }

  file { "${solr_home}/solr.xml":
    ensure    => 'file',
    owner     => 'jetty',
    group     => 'jetty',
    content   => template('solr/solr.xml.erb'),
    require   => File['/etc/default/jetty'],
  }

  file { "${jetty_home}/webapps/solr":
    ensure    => 'link',
    target    => $solr_home,
    require   => File["${solr_home}/solr.xml"],
  }

  solr::core { $cores:
    require   =>  File["${jetty_home}/webapps/solr"],
  }
}

