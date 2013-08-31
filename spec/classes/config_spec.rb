require 'spec_helper'

describe 'solr::config' do

  it { should contain_file('jetty-default').with({
    'ensure'    =>    'file',
    'path'      =>    '/etc/default/jetty',
    'source'    =>    'puppet:///modules/solr/jetty-default'})
    .with_require('Package[jetty]')
  }

  it { should contain_file('solr').with({
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'recurse' => 'true',
      'path'    => '/usr/share/solr',
      'source'  => 'puppet:///modules/solr/solr',
    })}

end
