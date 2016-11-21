require 'spec_helper'

describe 'solr::core', :type => :define do
  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Ubuntu',
      :operatingsystemrelease => '14.04',
    }
  end

  context 'default behaviour' do
    let(:title) { 'default' }

    it { should contain_file('/usr/share/solr/default').with({
      'ensure'    => 'directory',
      'owner'     => 'jetty',
      'group'     => 'jetty',
      'require'   => 'File[/usr/share/solr]'})
    }

    it { should contain_file('/usr/share/solr/default/conf').with({
      'ensure'    =>    'directory',
      'recurse'   =>    'true',
      'source'    =>    'puppet:///modules/solr/conf',
      'require'   =>    'File[/usr/share/solr/default]'})
    }

    it { should contain_file('/var/lib/solr/default').with({
      'ensure'    => 'directory',
      'owner'     => 'jetty',
      'group'     => 'jetty',
      'require'   => 'File[/usr/share/solr/default/conf]' })
    }
  end

  context 'link to a custom location' do
    let (:title) { 'linked' }
    let (:params) { {:config_type => 'link', :config_source => '/vagrant/custom_solr_test' } }

    it { should contain_file('/usr/share/solr/linked').with({
      'ensure'    => 'directory',
      'owner'     => 'jetty',
      'group'     => 'jetty',
      'require'   => 'File[/usr/share/solr]'})
    }

    it { should contain_file('/usr/share/solr/linked/conf').with({
      'ensure' => 'link',
      'owner' => 'jetty',
      'group' => 'jetty',
      'target' => '/vagrant/custom_solr_test',
      'require' => 'File[/usr/share/solr/linked]'})
    }

  end

end
