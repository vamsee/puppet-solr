# == Class: solr
#
# This module helps you create a multi-core solr install
# from scratch. I'm packaging a version of solr in the files
# directory for convenience. You can replace it with a newer
# version if you like.
#
# IMPORTANT: Works only with Ubuntu as of now. Other platform
# support is most welcome.
#
# === Parameters
#
# [*cores*]
#   "Specify the solr cores you want to create (optional)"
#
# === Examples
#
# Default case, which creates a single core called 'default'
#
#  include solr
#
# If you want multiple cores, you can supply them like so:
#
#  class { solr:
#    cores => [ 'development', 'staging', 'production' ]
#  }
#
# You can also manage/create your cores from solr web admin panel.
#
# === Authors
#
# Vamsee Kanakala <vkanakala AT gmail D0T com>
#
# === Copyright
#
# Copyright 2012 Vamsee Kanakala, unless otherwise noted.
#
class solr (
  $jetty_home = $solr::params::jetty_home,
  $solr_home  = $solr::params::solr_home,
  $cores      = $solr::params::cores,
) inherits solr::params {

  class {'solr::install': } ->
  class {'solr::config': } ~>
  class {'solr::service': } ->
  Class['solr']

#   #Copy the solr config file
#   file { 'solr.xml':
#     ensure => file,
#     path => "${solr_home}/solr.xml",
#     content => template('solr/solr.xml.erb'),
#     require => File['jetty-default'],
#   }
#
#   #Restart after copying new config
#   service { 'jetty':
#     ensure => running,
#     hasrestart => true,
#     hasstatus => true,
#     subscribe => File['solr.xml'],
#   }
#
#   #Create our solr cores
#   solr::core { $cores: }
#
}
