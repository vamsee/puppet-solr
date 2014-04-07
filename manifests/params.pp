# == Class: solr::params
# This class sets up some required parameters
#
# === Actions
# - Specifies jetty and solr home directories
# - Specifies the default core
#
class solr::params {

  $jetty_home = '/usr/share/jetty'
  $solr_home = '/usr/share/solr'
  $solr_version = '4.7.1'
  $cores = ['default']

}

