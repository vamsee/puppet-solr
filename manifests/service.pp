class solr::service {

  #restart after copying new config
  service { 'jetty':
    ensure      => running,
    hasrestart  => true,
    hasstatus   => true,
    #subscribe  => file['solr.xml'],
    require     => Package['solr-jetty'],
  }

}


