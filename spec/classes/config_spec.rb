require 'spec_helper'

describe 'solr::config' do

  it do
    should contain_file('solr').with({
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'recurse' => 'true',
      'path'    => '/usr/share/solr',
      'source'  => 'puppet:///modules/solr/solr',
    })
  end

end
