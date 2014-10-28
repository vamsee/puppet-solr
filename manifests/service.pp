# == Class: solr::service
# This class sets up solr service
#
# === Actions
# - Sets up jetty service
#
class solr::service {

  #restart after copying new config
  service { 'jetty':
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['jetty'],
  }

}


