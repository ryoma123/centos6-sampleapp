Package {
  allow_virtual => true
}

Exec {
  path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin']
}

package {
  [
    'httpd',
    'git',
    'yum',
    'patch',
    'gcc',
    'gcc-c++',
    'openssl',
    'openssl-devel',
    'readline',
    'readline-devel',
    'libxslt',
    'libxslt-devel',
    'libxml2',
    'libxml2-devel',
    'sqlite-devel',
    'mysql',
    'mysql-devel',
    'mysql-server',
  ]:
    ensure => installed
}

service {
  'iptables':
    enable => false,
    ensure => stopped;

  'mysqld':
    enable  => true,
    ensure  => running,
    require => Package['mysql'];
}

file {
  '/home/vagrant/.gemrc':
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => 644,
    source => '/vagrant/templates/.gemrc';

  '/home/vagrant/.bash_profile':
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => 644,
    source => '/vagrant/templates/.bash_profile';
}
