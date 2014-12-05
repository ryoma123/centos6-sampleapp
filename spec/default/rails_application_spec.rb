require 'spec_helper'

describe 'Installed packages' do
  packages = %w(
    httpd
    git
    gcc
    gcc-c++
    openssl
    openssl-devel
    readline
    readline-devel
    libxslt
    libxslt-devel
    libxml2
    libxml2-devel
    sqlite-devel
    mysql
    mysql-devel
    mysql-server
    patch
  )

  packages.each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end
end

describe 'Rails setup' do
  describe 'Ruby is installed' do
    describe command('/home/vagrant/.rbenv/shims/ruby -v') do
      its(:stdout) { should match /2\.1\.\d/ }
    end
  end

  describe 'Application is installed' do
    describe file('/home/vagrant/sample_app2') do
      it { should be_directory }
      it { should be_mode         755 }
      it { should be_owned_by     'vagrant' }
      it { should be_grouped_into 'vagrant' }
    end

    describe file('/home/vagrant/sample_app2/vendor/bundle/ruby/2.1.0/gems') do
      it { should be_directory }
      it { should be_mode         775 }
      it { should be_owned_by     'vagrant' }
      it { should be_grouped_into 'vagrant' }
    end
  end

  describe 'Setting of rbenv' do
    describe file('/home/vagrant/.bash_profile') do
      its(:content) { should match %r|export PATH="\$HOME/\.rbenv/bin:\$PATH"| }
      its(:content) { should match %r|eval "\$\(rbenv init -\)"| }
    end

    describe file('/home/vagrant/.rbenv/version') do
      its(:content) { should match /2\.1\.\d/ }
    end

    describe command('/home/vagrant/.rbenv/shims/gem -v') do
      its(:stdout) { should match /2\.2\.\d/ }
    end

    describe file('/home/vagrant/.rbenv/shims/bundler') do
      it { should be_file }
      it { should be_mode         775 }
      it { should be_owned_by     'vagrant' }
      it { should be_grouped_into 'vagrant' }
    end
  end
end

describe 'Build mysql' do
  describe service('mysqld') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/var/lib/mysql') do
    it { should be_directory }
    it { should be_mode         755 }
    it { should be_owned_by     'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe file('/var/lib/mysql/mysql.sock') do
    it { should be_socket }
    it { should be_mode         777 }
    it { should be_owned_by     'mysql' }
    it { should be_grouped_into 'mysql' }
  end
end

# テスト環境のため iptables を off にしています
describe 'Firewall is stopped' do
  describe service('iptables') do
    it { should_not be_enabled }
    it { should_not be_running }
  end
end

describe 'Running rails server' do
  describe service('rails') do
    it { should be_running }
  end

  describe port(3000) do
    it { should be_listening.with('tcp') }
  end
end
