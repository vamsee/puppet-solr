require 'spec_helper'

describe command('ls /usr/share/solr') do
  it { should return_exit_status 0 }
end

describe file('/var/lib/solr') do
  it { should be_directory }
end

# describe file('/usr/share/solr') do
#   it { should be_linked_to '/usr/share/jetty/webapps/solr' }
# end

