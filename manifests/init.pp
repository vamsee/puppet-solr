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
# Document parameters here.
#
# [*cores*]
#   "Specify the solr cores you want to create"    
#
# === Examples
#
#  class { solr:
#    cores => [ 'development', 'staging', 'production' ]
#  }
#
# === Authors
#
# Vamsee Kanakala <vkanakala AT gmail D0T com>
#
# === Copyright
#
# Copyright 2012 Vamsee Kanakala, unless otherwise noted.
#
class solr ($cores = ['development','test']) {
  
  $jetty_home = "/usr/share/jetty"
  $solr_home = "/usr/share/solr"

  package { 'default-jdk':
    ensure => present,
  }
 
  package { 'solr-jetty':
    ensure => present,
    require => Package['default-jdk'],
  }

  #Copy the jetty config file
  file { 'jetty-default':
    ensure => file,
    path => "/etc/default/jetty",
    source => "puppet:///modules/solr/jetty-default",
    notify => Service['jetty'],
    require => Package['solr-jetty'],
  }

  #restart after copying new config
  service { 'jetty':
    ensure => running,
    hasrestart => true,
    hasstatus => true,
    #subscribe => file['solr.xml'],
    require => Package['solr-jetty'],
  }

#   #removes existing solr install
#   exec { 'rm-web-inf':
#     command => "rm -rf ${solr_home}/web-inf",
#     path => ["/usr/bin", "/usr/sbin", "/bin"],
#     onlyif => "test -d ${solr_home}/web-inf",
#     require => package['solr-jetty'],
#   }
# 
#   #removes existing solr config
#   exec { 'rm-default-conf':
#     command => "rm -rf ${solr_home}/conf",
#     path => ["/usr/bin", "/usr/sbin", "/bin"],
#     onlyif => "test -d ${solr_home}/conf",
#     require => exec['rm-web-inf'],
#   }
# 
#   #removes existing solr webapp in jetty
#   exec { 'rm-solr-link':
#     command => "rm -rf ${jetty_home}/webapps/solr",
#     path => ["/usr/bin", "/usr/sbin", "/bin"],
#     onlyif => "test -L ${jetty_home}/webapps/solr",
#     require => Exec['rm-default-conf'],
#   }
# 
#   #Replaces with our newer version. You can download the
#   #latest version and add it if you need latest features. 
#   file { 'solr.war':
#     ensure => file,
#     path => "${jetty_home}/webapps/solr.war",
#     source => "puppet:///modules/solr/solr.war",
#     require => Exec['rm-solr-link'],
#   }
# 
#   #Add a new solr context to jetty
#   file { 'jetty-context.xml':
#     ensure => file,
#     path => "${jetty_home}/contexts/solr.xml",
#     source => "puppet:///modules/solr/jetty-context.xml",
#     require => File['solr.war'],
#   }
# 
 
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
