require 'spec_helper'

describe 'solr::install' do

  let :facts do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Ubuntu',
      :operatingsystemrelease => '14.04',
    }
  end

  it { should contain_package('default-jdk').with_ensure('present') }
  it { should contain_package('jetty').with_ensure('present') }
  it { should contain_package('libjetty-extra').with_ensure('present') }
  it { should contain_package('wget').with_ensure('present') }
  it { should contain_package('curl').with_ensure('present') }

end
