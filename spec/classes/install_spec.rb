require 'spec_helper'

describe 'solr::install' do

  it { should contain_package('default-jdk').with_ensure('present') }
  it { should contain_package('solr-jetty').with_ensure('present') }

end
