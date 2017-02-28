# == Class: solr::params
# This class sets up some required parameters
#
# === Actions
# - Specifies jetty and solr home directories
# - Specifies the default core
#
class solr::params {

  if $::lsbdistcodename == 'trusty' {
    $jetty_home    = '/usr/share/jetty'
  } else {
    $jetty_home    = '/usr/share/jetty8'
  }
  $solr_home     = '/usr/share/solr'
  $solr_version  = '4.7.2'
  $mirror_site   = 'http://www.us.apache.org/dist/lucene/solr'
  $data_dir      = '/var/lib/solr'
  $cores         = ['default']
  $dist_root     = '/tmp'
  if $::lsbdistcodename == 'trusty' {
    $jetty_package = 'jetty'
  } else {
    $jetty_package = 'jetty8'
  }
}
