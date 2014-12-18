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

exec {
  'rbenv':
    user        => 'vagrant',
    environment => 'HOME=/home/vagrant',
    command     => 'git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv',
    creates     => '/home/vagrant/.rbenv',
    require     => Package['git'];

  'ruby build':
    user        => 'vagrant',
    environment => 'HOME=/home/vagrant',
    command     => 'git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build',
    creates     => '/home/vagrant/.rbenv/plugins/ruby-build',
    require     => [
      Package['git'],
      Exec['rbenv'],
    ];

  'Ruby install':
    cwd         => '/home/vagrant',
    user        => 'vagrant',
    environment => 'HOME=/home/vagrant',
    command     => "bash -c 'source /home/vagrant/.bash_profile ; makeopts=\"-j4\" configure_opts=\"--disable-install-doc\" rbenv install 2.1.5 ; rbenv global 2.1.5 ; rbenv rehash'",
    timeout     => 1800,
    require     => [
      File['/home/vagrant/.bash_profile'],
      Exec['ruby build'],
      Exec['rbenv'],
    ];
}
