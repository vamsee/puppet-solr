# == Class: solr::service
# This class sets up solr service
#
# === Actions
# - Sets up jetty service
#
class solr::service {

  if versioncmp($::solr::version, '5.0') < 0 {
    #restart after copying new config
    service { 'jetty':
      ensure     => running,
      hasrestart => true,
      hasstatus  => true,
      require    => Package['jetty'],
    }
  }
}


