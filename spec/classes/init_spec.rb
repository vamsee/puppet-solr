require 'spec_helper'

describe 'solr' do

  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Ubuntu',
      :operatingsystemrelease => '14.04',
    }
  end
  
  context "where params are not passed (default case)" do

    it { should contain_class('solr::params') }

    it { should contain_class('solr::install') }

    it { should contain_class('solr::config')
        .with({
                'cores'     => ['default'],
                'version'   => '4.7.2',
                'mirror'    => 'http://www.us.apache.org/dist/lucene/solr',
                'dist_root' => '/tmp',
              })
    }

    it { should contain_class('solr::service') }

  end

  context "where params are passed" do

    let(:params) { {
        :cores       => ['dev', 'prod'],
        :version     => '5.6.2',
        :mirror      => 'http://some-random-site.us',
        :dist_root   => '/opt/tmpdata',
    } }

    it { should contain_class('solr::params') }

    it { should contain_class('solr::install') }

    it { should contain_class('solr::config')
        .with({
                'cores'      => ['dev', 'prod'],
                'version'    => '5.6.2',
                'mirror'     => 'http://some-random-site.us',
                'dist_root'  => '/opt/tmpdata'
              })
    }

    it { should contain_class('solr::service') }

  end

end
