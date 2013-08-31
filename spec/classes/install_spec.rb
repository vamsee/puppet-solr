require 'spec_helper'

describe 'solr::install' do

  it { should contain_package('default-jdk').with_ensure('present') }
  it { should contain_package('jetty').with_ensure('present') }
  it { should contain_package('libjetty-extra').with_ensure('present') }

end
