require 'spec_helper'

# iptables
describe service('iptables') do
  it { should_not be_enabled }
  it { should_not be_running }
end

# mysql
describe service('mysqld') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/var/lib/mysql/mysql.sock') do
  it { should be_socket }
end

# rails
describe service('rails') do
  it { should be_running }
end

# port
describe port(3000) do
  it { should be_listening.with('tcp') }
end

# ruby
describe command('/home/vagrant/.rbenv/shims/ruby -v') do
  its(:stdout) { should match /2.1.4/ }
end

describe file('/home/vagrant/.rbenv/version') do
  its(:content) { should match /2.1.4/ }
end

# ebenv
describe file('/home/vagrant/.bash_profile') do
  its(:content) { should match /export PATH="\$HOME\/\.rbenv\/bin:\$PATH"/ }
  its(:content) { should match /eval "\$\(rbenv init -\)"/ }
end

# sample_app2
describe file('/home/vagrant/sample_app2') do
  it { should be_directory }
end

# bundler
describe file('/home/vagrant/.rbenv/shims/bundler') do
  it { should be_file }
end

describe file('/home/vagrant/sample_app2/vendor/bundle/ruby/2.1.0/gems') do
  it { should be_directory }
end

# packages
describe 'installed packages' do
  packages = %w(
    httpd
    git
    yum
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
    mysql-server
  )

  packages.each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end
end
