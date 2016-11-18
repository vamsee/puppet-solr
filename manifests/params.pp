# == Class: solr::params
# This class sets up some required parameters
#
# === Actions
# - Specifies jetty and solr home directories
# - Specifies the default core
#
class solr::params {

  $solr_home     = '/usr/share/solr'
  $solr_version  = '4.7.2'
  $mirror_site   = 'http://www.us.apache.org/dist/lucene/solr'
  $data_dir      = '/var/lib/solr'
  $cores         = ['default']
  $dist_root     = '/tmp'

  case $::operatingsystem {
    'Debian': {
      case $::facts['os']['release']['major'] {
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
