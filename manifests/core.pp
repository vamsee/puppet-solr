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

  $solr_home  = $::solr::params::solr_home
  $data_dir   = $::solr::params::data_dir

  $jetty_service = $::solr::params::jetty_service
  $jetty_user = $::solr::params::jetty_user
  $jetty_group = $::solr::params::jetty_group

  file { "${solr_home}/${core_name}":
    ensure  => directory,
    owner   => $jetty_user,
    group   => $jetty_group,
    require => File[$solr_home],
  }

  case $config_type {
    'directory': {
      #Copy its config over
      file { "${solr_home}/${core_name}/conf":
        ensure  => directory,
        owner   => $jetty_user,
        group   => $jetty_group,
        recurse => true,
        replace => false,
        source  => $config_source,
        require => File["${solr_home}/${core_name}"],
        }
    }
    'link': {
      # Link the config directory
      file {"${solr_home}/${core_name}/conf":
        ensure  => 'link',
        owner   => $jetty_user,
        group   => $jetty_group,
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
  file { "${data_dir}/${core_name}":
    ensure  => directory,
    owner   => $jetty_user,
    group   => $jetty_group,
    require => File["${solr_home}/${core_name}/conf"],
  }

  xml_fragment { "${core_name}_config":
    path    => "${solr_home}/solr.xml",
    xpath   => "/solr/cores/core[@name='${core_name}']",
    content => {
      attributes => {
        name        => $core_name,
        instanceDir => "${solr_home}/${core_name}",
        dataDir     => "${data_dir}/${core_name}",
      },
    },
    require => File["${data_dir}/${core_name}"],
    notify  => Service[$jetty_service],
  }

}
