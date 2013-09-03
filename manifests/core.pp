define solr::core(
  $core_name  = $title,
) {
  include solr::params
  include solr::config

  $solr_home  = $solr::params::solr_home

  file { "${solr_home}/${core_name}":
    ensure  => directory,
    owner   => 'jetty',
    group   => 'jetty',
    require => File[$solr_home],
  }

  #Copy its config over
  file { "${solr_home}/${core_name}/conf":
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/solr/conf',
    require => File["${solr_home}/${core_name}"],
  }

  #Finally, create the data directory where solr stores
  #its indexes with proper directory ownership/permissions.
  file { "/var/lib/solr/${core_name}":
    ensure  => directory,
    owner   => 'jetty',
    group   => 'jetty',
    require => File["${solr_home}/${core_name}/conf"],
  }

}
