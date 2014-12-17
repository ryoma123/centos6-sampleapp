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
