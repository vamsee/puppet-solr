# == Class: solr::params
# This class sets up some required parameters
#
# === Actions
# - Specifies jetty and solr home directories
# - Specifies the default core
#
class solr::params {
  $listen_address = '0.0.0.0'
  $listen_port    = 8983

  $solr_home      = '/usr/share/solr'
  $solr_version   = '4.7.2'
  $mirror_site    = 'http://www.us.apache.org/dist/lucene/solr'
  $data_dir       = '/var/lib/solr'
  $cores          = ['default']
  $dist_root      = '/tmp'

  $jetty_user     = 'jetty'
  $jetty_group    = 'jetty'

  case $::operatingsystem {
    'Debian': {
      case $::operatingsystemmajrelease {
        '8': {
          $jetty_package = 'jetty8'
          $jetty_service = 'jetty8'
          $jetty_home    = '/usr/share/jetty8'
        }
        default: {
          $jetty_package = 'jetty'
          $jetty_service = 'jetty'
          $jetty_home    = '/usr/share/jetty'
        }
      }
    }
    default: {
      $jetty_package = 'jetty'
      $jetty_service = 'jetty'
      $jetty_home    = '/usr/share/jetty'
    }
  }

}
