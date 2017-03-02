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

  case $::lsbdistcodename {
    'precise': {
      $jetty_package = 'jetty'
      $jdk_dirs = '/usr/lib/jvm/default-java /usr/lib/jvm/java-6-sun'
    }

    'trusty': {
      $jetty_package = 'jetty'
      $jdk_dirs = '/usr/lib/jvm/default-java /usr/lib/jvm/java-7-openjdk-amd64'
    }

    default: {
      $jetty_package = 'jetty8'
      $jdk_dirs = '/usr/lib/jvm/default-java /usr/lib/jvm/java-7-openjdk-amd64'
    }
}
