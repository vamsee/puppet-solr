require 'spec_helper'

describe command('ls /usr/share/solr') do
  it { should return_exit_status 0 }
end 
