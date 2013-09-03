require 'spec_helper'

describe file('/usr/share/solr') do
  it { should be_directory }
  it { should be_owned_by 'jetty' }
  it { should be_grouped_into 'jetty' }
end

describe file('/var/lib/solr') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'jetty' }
  it { should be_grouped_into 'jetty' }
end

describe file('/usr/share/solr/solr.xml') do
  it { should be_file }
end

describe file('/usr/share/jetty/webapps/solr') do
 it { should be_linked_to '/usr/share/solr' }
end

describe file('/usr/share/solr') do
  it { should be_directory }
  it { should be_owned_by 'jetty' }
  it { should be_grouped_into 'jetty' }
end

describe file('/usr/share/solr/default') do
  it { should be_directory }
  it { should be_owned_by 'jetty' }
  it { should be_grouped_into 'jetty' }
end

describe file('/var/lib/solr/default') do
  it { should be_directory }
  it { should be_owned_by 'jetty' }
  it { should be_grouped_into 'jetty' }
end

