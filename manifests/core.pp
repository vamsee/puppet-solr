# == Definition: solr::core
# This definition sets up solr config and data directories for each core
#
# === Parameters
#
# [*core_name*]:: The core to create. Defaults to the title of the resource
# [*config_source*]:: Path to the config source. Defaults to `puppet:///modules/solr/conf`
# [*config_type*]:: Type of the configuration. Possible values are 'directory' or 'link'.
#                   If the config_type is set to `directory`, it will be copied recursivly.
#                   If set to `link`, the config_source will be used as the target.
#
# === Actions
# - Creates the solr web app directory for the core
# - Copies over the config directory for the file
# - Creates the data directory for the core
#
define solr::core(
  $core_name = $title,
  $config_source = 'puppet:///modules/solr/conf',
  $config_type = 'directory',
) {
  include solr::params

  $solr_home  = $solr::params::solr_home

  if versioncmp($::solr::version, '5.0') < 0 {

    file { "${solr_home}/${core_name}":
      ensure  => directory,
      owner   => 'jetty',
      group   => 'jetty',
      require => File[$solr_home],
    }

    case $config_type {
      'directory': {
        #Copy its config over
        file { "${solr_home}/${core_name}/conf":
          ensure  => directory,
          owner   => 'jetty',
          group   => 'jetty',
          recurse => true,
          source  => $config_source,
          require => File["${solr_home}/${core_name}"],
        }
      }
      'link': {
        # Link the config directory
        file {"${solr_home}/${core_name}/conf":
          ensure  => 'link',
          owner   => 'jetty',
          group   => 'jetty',
          target  => $config_source,
          require => File["${solr_home}/${core_name}"],
        }
      }
      default: {
        fail('Unsupported value for parameter config_type')
      }
    }

    #Finally, create the data directory where solr stores
    #its indexes with proper directory ownership/permissions.
    file { "/var/lib/solr/${core_name}":
      ensure  => directory,
      mode    => '2770',
      owner   => 'jetty',
      group   => 'jetty',
      require => File["${solr_home}/${core_name}/conf"],
    }
  } else {
    ## SOLR 5 core install section
    file { "/var/lib/solr/data/${core_name}":
      ensure => directory,
      mode   => '2770',
      owner  => 'solr',
      group  => 'solr',
    }
    case $config_type {
      'directory': {
        #Copy its config over
        file { "/var/lib/solr/data/${core_name}/conf":
          ensure  => directory,
          owner   => 'solr',
          group   => 'solr',
          recurse => true,
          source  => $config_source,
          require => File["/var/lib/solr/data/${core_name}"],
        }
      }
      'link': {
        # Link the config directory
        file {"/var/lib/solr/data/${core_name}/conf":
          ensure  => 'link',
          owner   => 'solr',
          group   => 'solr',
          target  => $config_source,
          require => File["/var/lib/solr/data/${core_name}"],
        }
      }
      default: {
        fail('Unsupported value for parameter config_type')
      }
    }
    exec { 'create-solr5-cores':
      command => "curl 'http://localhost:8983/solr/admin/cores?action=CREATE&name=${core_name}&instanceDir=${core_name}'",
      creates => "/var/lib/solr/data/${core_name}/core.properties",
      require => File["/var/lib/solr/data/${core_name}/conf"],
    }
  }
}
