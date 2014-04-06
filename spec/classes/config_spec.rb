require 'spec_helper'

describe 'solr::config' do
  let(:params) { {:cores => ['default']} }

  it { should contain_solr__params }

  it { should contain_file('/etc/default/jetty').with({
    'ensure'    =>    'file',
    'source'    =>    'puppet:///modules/solr/jetty-default',
    'require'   =>    'Package[jetty]'})
  }

  it { should contain_file('/usr/share/solr').with({
    'ensure'  =>  'directory',
    'owner'   =>  'jetty',
    'group'   =>  'jetty',
    'require' =>  'Package[jetty]',
  })}

  it { should contain_file('/var/lib/solr').with({
    'ensure'    => 'directory',
    'owner'     => 'jetty',
    'group'     => 'jetty',
    'mode'      => '0700',
    'require'   => 'Package[jetty]'})
  }

  it { should contain_file('/usr/share/solr/solr.xml').with({
    'ensure'    => 'file',
    'owner'     => 'jetty',
    'group'     => 'jetty',
    'content'   => /\/var\/lib\/solr\/default/,
    'require'   => 'File[/etc/default/jetty]'})
  }

  it { should contain_file('/usr/share/jetty/webapps/solr').with({
    'ensure'    => 'link',
    'target'    => '/usr/share/solr',
    'require'   => 'File[/usr/share/solr/solr.xml]'})
  }

  it { should contain_solr__core('default').with({
    'require'   => 'File[/usr/share/jetty/webapps/solr]'}) 
  }

  it { should contain_exec('solr-download').with({
    'command'   =>  'wget http://www.eng.lsu.edu/mirrors/apache/lucene/solr/4.7.1/solr-4.7.1.tgz',
    'cwd'       =>  '/tmp',
    'creates'   =>  '/tmp/solr-4.7.1.tgz',
    'onlyif'    =>  'test ! -d /usr/share/solr/WEB-INF && test ! -f /tmp/solr-4.7.1.tgz',
    'timeout'   =>  0,
    'require'   =>  'File[/usr/share/solr]'})  
  }

  it { should contain_exec('extract-solr').with({
    'path'      =>  '["/usr/bin", "/usr/sbin", "/bin"]',
    'command'   =>  'tar xzvf solr-4.7.1.tgz',
    'cwd'       =>  '/tmp',
    'onlyif'    =>  'test -f /tmp/solr-4.7.1.tgz && test ! -d /tmp/solr-4.7.1',
    'require'   =>  'Exec[solr-download]', })
  }

  it { should contain_exec('copy-solr').with({
    'path'      =>  '["/usr/bin", "/usr/sbin", "/bin"]',
    'command'   =>  'jar xvf /tmp/solr-4.7.1/dist/solr-4.7.1.war; cp /tmp/solr-4.7.1/example/lib/ext/*.jar WEB-INF/lib',
    'cwd'       =>  '/usr/share/solr',
    'onlyif'    =>  'test ! -d /usr/share/solr/WEB-INF',
    'require'   =>  'Exec[extract-solr]' })
  }

end
