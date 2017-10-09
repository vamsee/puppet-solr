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
#  class { 'solr':
#    cores => [ 'development', 'staging', 'production' ]
#  }
#
# You can also manage/create your cores from solr web admin panel.
#
# === Authors
#
# Vamsee Kanakala <vamsee AT riseup D0T net>
#
# === Copyright
#
# Copyright 2012-2013 Vamsee Kanakala, unless otherwise noted.
#

class solr (
  $listen_address = $::solr::params::listen_address,
  $listen_port    = $::solr::params::listen_port,
  $cores          = $::solr::params::cores,
  $version        = $::solr::params::solr_version,
  $mirror         = $::solr::params::mirror_site,
  $dist_root      = $::solr::params::dist_root,
) inherits ::solr::params {

  include solr::params

  validate_ip_address($listen_address)
  validate_integer($listen_port)

  class {'solr::install': } ->
  class {'solr::config':
    listen_address => $listen_address,
    listen_port    => $listen_port,
    cores          => $cores,
    version        => $version,
    mirror         => $mirror,
    dist_root      => $dist_root,
  } ~>
  class {'solr::service': } ->
  Class['solr']

}
