require 'spec_helper'

describe 'solr::config' do

  it { should contain_package('default-jdk').with_ensure('present') }

end
