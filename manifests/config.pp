# == Class: solr::config
# This class sets up solr install
#
# === Parameters
# - The $cores to create
#
# === Actions
# - Copies a new jetty default file
# - Creates solr home directory
# - Downloads the required solr version, extracts war and copies logging jars
# - Creates solr data directory
# - Creates solr config file with cores specified
# - Links solr home directory to jetty webapps directory
#
class solr::config(
  $cores          = $solr::params::cores,
  $version        = $solr::params::solr_version,
  $mirror         = $solr::params::mirror_site,
  $jetty_home     = $solr::params::jetty_home,
  $solr_home      = $solr::params::solr_home,
  $dist_root      = $solr::params::dist_root,
  $jetty_package  = $solr::params::jetty_package,
  $jdk_dirs       = $solr::params::jdk_dirs,
  ) inherits solr::params {

  if versioncmp($::solr::version, '4.1') < 0 {
    $solr_name      = "apache-solr-${version}"
  } else {
    $solr_name      = "solr-${version}"
  }
  $dl_name        = "${solr_name}.tgz"
  $download_url   = "${mirror}/${version}/${dl_name}"

  $jsp_jar = 'jsp-2.1-6.0.2.jar'
  $jsp_url = "http://uk.maven.org/maven2/jetty/jsp/2.1-6.0.2/${jsp_jar}"

  # This works for versions < 5.0 
  if versioncmp($::solr::version, '5.0') < 0 {

    #Copy the jetty config file
    file { "/etc/default/${jetty_package}":
      ensure  => file,
      content => template('solr/jetty-default.erb'),
      require => Package[$jetty_package],
    }

    file { $solr_home:
      ensure  => directory,
      owner   => 'jetty',
      group   => 'jetty',
      require => Package[$jetty_package],
    }

    file { '/var/lib/solr':
      ensure  => directory,
      owner   => 'jetty',
      group   => 'jetty',
      mode    => '0700',
      require => Package[$jetty_package],
    }

    file { "${solr_home}/solr.xml":
      ensure  => 'file',
      owner   => 'jetty',
      group   => 'jetty',
      content => template('solr/solr.xml.erb'),
      require => File["/etc/default/${jetty_package}"],
    }

    # download only if WEB-INF is not present and tgz file is not in $dist_root:
    exec { 'solr-download':
      path    => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
      command =>  "wget ${download_url}",
      cwd     =>  $dist_root,
      creates =>  "${dist_root}/${dl_name}",
      onlyif  =>  "test ! -d ${solr_home}/WEB-INF && test ! -f ${dist_root}/${dl_name}",
      timeout =>  0,
      require => File[$solr_home],
    }

    exec { 'extract-solr':
      path    => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
      command =>  "tar xvf ${dl_name}",
      cwd     =>  $dist_root,
      onlyif  =>  "test -f ${dist_root}/${dl_name} && test ! -d ${dist_root}/${solr_name}",
      require =>  Exec['solr-download'],
    }

    # have to copy logging jars separately from solr 4.3 onwards
    exec { 'copy-solr':
      path    => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
      command =>  "jar xvf ${dist_root}/${solr_name}/dist/${solr_name}.war",
      cwd     =>  $solr_home,
      onlyif  =>  "test ! -d ${solr_home}/WEB-INF",
      require =>  Exec['extract-solr'],
    }
    if versioncmp($::solr::version, '4.3') >= 0 {
      exec { 'copy-solr-extra':
        path    => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
        command =>  "cp ${dist_root}/${solr_name}/example/lib/ext/*.jar WEB-INF/lib",
        cwd     =>  $solr_home,
        onlyif  =>  "test ! -f ${solr_home}/WEB-INF/lib/log4j*.jar",
        require =>  Exec['extract-solr'],
      }
    }
    if versioncmp($::solr::version, '3.6.2') == 0 {
      exec { 'download-jsp':
        path    => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
        command =>  "wget ${jsp_url}",
        cwd     =>  "${jetty_home}/lib",
        creates =>  "${jetty_home}/lib/${jsp_jar}",
        timeout =>  0,
      }
    }

    file { "${jetty_home}/webapps/solr":
      ensure  => 'link',
      target  => $solr_home,
      require => File["${solr_home}/solr.xml"],
    }

    if is_hash($cores) {
      create_resources('::solr::core', $cores, {})
    }
    elsif is_array($cores) or is_string($cores) {
      solr::core { $cores:
        require   =>  File["${jetty_home}/webapps/solr"],
      }
    }
    else {
      fail('Parameter cores must be a hash, array or string')
    }
  } else {
    # SOLR 5.x or higher install  here

    # download only if WEB-INF is not present and tgz file is not in $dist_root:
    exec { 'solr-download':
      path    => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
      command =>  "wget ${download_url}",
      cwd     =>  $dist_root,
      creates =>  "${dist_root}/${dl_name}",
      onlyif  =>  "test ! -d ${solr_home}/WEB-INF && test ! -f ${dist_root}/${dl_name}",
      timeout =>  0,
    }

    exec { 'extract-solr':
      path    => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
      command =>  "tar xvf ${dl_name}",
      cwd     =>  $dist_root,
      onlyif  =>  "test -f ${dist_root}/${dl_name} && test ! -d ${dist_root}/${solr_name}",
      require =>  Exec['solr-download'],
    }

    exec { 'install-solr':
      path    => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin', '/usr/local/bin', "${dist_root}/${solr_name}/bin" ],
      command =>  "install_solr_service.sh ${dist_root}/${dl_name} -d ${::solr::params::data_dir}",
      cwd     =>  "${dist_root}/${solr_name}",
      onlyif  =>  "test ! -d /opt/${solr_name}",
      require =>  Exec['extract-solr'],
    }

    if is_hash($cores) {
      create_resources('::solr::core', $cores, {})
    }
    elsif is_array($cores) or is_string($cores) {
      solr::core { $cores: }
    }
    else {
      fail('Parameter cores must be a hash, array or string')
    }
  }
}
