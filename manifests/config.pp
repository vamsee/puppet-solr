class solr::config(
  $cores      = 'UNSET'
) {
  include solr::params

  $jetty_home = $::solr::params::jetty_home
  $solr_home  = $solr::params::solr_home

  $all_cores = $cores ? {
    'UNSET'   => $::solr::params::cores,
    default   => $cores,
  }

  #Copy the jetty config file
  file { '/etc/default/jetty':
    ensure  => file,
    source  => 'puppet:///modules/solr/jetty-default',
    # notify  => Service['jetty'],
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

}

