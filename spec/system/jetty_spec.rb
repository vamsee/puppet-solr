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

describe file('/etc/default/jetty') do
  it { should contain "-Dsolr.solr.home=/usr/share/solr $JAVA_OPTIONS" }
end

describe command("curl -IL 'http://0.0.0.0:8080/solr'") do
  it { should return_stdout(/HTTP\/1.1 200 OK/) }
end
