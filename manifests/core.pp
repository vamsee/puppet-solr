define solr::core() {

  $solr_home = "/usr/share/solr"

  #Create this core's config directory
  exec { "mkdir-p-${title}":
    path => ['/usr/bin', '/usr/sbin', '/bin'],
    command => "mkdir -p ${solr_home}/${title}",
    unless => "test -d ${solr_home}/${title}",
  }

  #Copy its config over
  file { "core-${title}-conf":    
    ensure => directory,
    recurse => true,
    path => "${solr_home}/${title}/conf",
    source => "puppet:///modules/solr/conf/",
    require => Exec["mkdir-p-${title}"],
  }

  #Copy the respective solrconfig.xml file
  file { "solrconfig-${title}":
    ensure => file,
    path => "${solr_home}/${title}/conf/solrconfig.xml",
    content => template('solr/solrconfig.xml.erb'),
    require => File["core-${title}-conf"],
  }

  #Finally, create the data directory where solr stores
  #its indexes with proper directory ownership/permissions.
  file { "${title}-data-dir":
    ensure => directory,
    path => "/var/lib/solr/${title}",
    owner => "jetty",
    group => "jetty",
    require => File["solrconfig-${title}"],
    before => File['solr.xml'],
  }
  
}
