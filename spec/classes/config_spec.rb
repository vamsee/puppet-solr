require 'spec_helper'

describe 'solr::config' do

  it { should contain_file('/etc/default/jetty').with({
    'ensure'    =>    'file',
    'source'    =>    'puppet:///modules/solr/jetty-default',
    'require'   =>    'Package[jetty]'})
  }

  it { should contain_file('/usr/share/solr').with({
    'ensure'  => 'directory',
    'owner'   => 'jetty',
    'group'   => 'jetty',
    'recurse' => 'true',
    'source'  => 'puppet:///modules/solr/solr',
  })}

  it { should contain_file('/var/lib/solr').with({
    'ensure'    => 'directory',
    'owner'     => 'jetty',
    'group'     => 'jetty',
    'mode'      => '0700',
    'require'   => 'Package[jetty]'})
  }

  it { should contain_file('/usr/share/solr/solr.xml').with({
    'ensure'    => 'file',
    'owner'     => 'jetty',
    'group'     => 'jetty',
    'content'   => /\/var\/lib\/solr\/default/,
    'require'   => 'File[/etc/default/jetty]'})
  }

  it { should contain_file('/usr/share/jetty/webapps/solr').with({
    'ensure'    => 'link',
    'target'    => '/usr/share/solr',
    'require'   => 'File[/usr/share/solr/solr.xml]'})
  }

end
