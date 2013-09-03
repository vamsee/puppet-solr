require 'spec_helper'

describe 'solr::config' do

  it { should contain_file('jetty-default').with({
    'ensure'    =>    'file',
    'path'      =>    '/etc/default/jetty',
    'source'    =>    'puppet:///modules/solr/jetty-default',
    'require'   =>    'Package[jetty]'})
  }

  it { should contain_file('solr-dir').with({
    'ensure'  => 'directory',
    'owner'   => 'jetty',
    'group'   => 'jetty',
    'recurse' => 'true',
    'path'    => '/usr/share/solr',
    'source'  => 'puppet:///modules/solr/solr',
  })}

  it { should contain_file('solr-data').with({
    'ensure'    => 'directory',
    'owner'     => 'jetty',
    'group'     => 'jetty',
    'mode'      => '0700',
    'path'      => '/var/lib/solr',
    'require'   => 'Package[jetty]'})
  }

  it { should contain_file('solr.xml').with({
    'ensure'    => 'file',
    'path'      => "/usr/share/solr/solr.xml",
    'owner'     => 'jetty',
    'group'     => 'jetty',
    'content'   => /\/var\/lib\/solr\/default/,
    'require'   => 'File[jetty-default]'})
  }

  it { should contain_file('/usr/share/jetty/webapps/solr').with({
    'ensure'    => 'link',
    'target'    => '/usr/share/solr',
    'require'   => 'File[solr.xml]'})
  }

end
