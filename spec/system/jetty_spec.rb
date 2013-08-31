require 'spec_helper'

describe package('jetty') do
  it { should be_installed }
end

describe service('jetty') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(8080) do
  it { should be_listening }
end

# describe file('/etc/httpd/conf/httpd.conf') do
#   it { should be_file }
#   it { should contain "ServerName default" }
# end

