class solr::config( 
  $jetty_home = $solr::params::jetty_home,
  $solr_home  = $solr::params::solr_home,
  $cores      = $solr::params::cores,
) inherits solr::params {

  #Copy the jetty config file
  file { 'jetty-default':
    ensure  => 'file',
    path    => '/etc/default/jetty',
    source  => 'puppet:///modules/solr/jetty-default',
    # notify  => Service['jetty'],
    require => 'Package[jetty]',
  }

  file { 'solr':
    ensure    => 'directory',
    owner     => 'jetty',
    group     => 'jetty',
    recurse   => 'true',
    path      => '/usr/share/solr',
    source    => 'puppet:///modules/solr/solr',
  }

  file { 'solr-data':
    ensure    => 'directory',
    owner     => 'jetty',
    group     => 'jetty',
    mode      => '0700',
    path      => '/var/lib/solr',
    require   => 'Package[jetty]',
  }

  file { 'solr.xml':
    ensure    => 'file',
    path      => "${solr_home}/solr.xml",
    owner     => 'jetty',
    group     => 'jetty',
    require   => 'File[jetty-default]',
    content   => template('solr/solr.xml.erb'),
  }

}

