require 'spec_helper'

describe 'solr::config' do

  it { should contain_file('jetty-default').with({
    'ensure'    =>    'file',
    'path'      =>    '/etc/default/jetty',
    'source'    =>    'puppet:///modules/solr/jetty-default',
    'require'   =>    'Package[jetty]'})
  }

  it { should contain_file('solr').with({
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

end
