#!/bin/bash

set -x
set -e
set -u

PATH=/bin:/sbin:/usr/bin:/usr/sbin

# package のインストール
packages=(
    httpd
    git
    yum
    patch
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
)

yum -y install "${packages[@]}"

# gem インストール時にドキュメントを保存しない
cat <<'EOS' > /home/vagrant/.gemrc
gem: --no-ri --no-rdoc
EOS

# rbenv を clone する
if [ -d /home/vagrant/.rbenv ]; then
    :
    : rbenv already installed
else
    su - vagrant -c 'git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv'
fi

# bash_profile にrbenv のパスを保存する
cat <<'EOS' > /home/vagrant/.bash_profile
[ -f ~/.bashrc ] && . ~/.bashrc
export PATH=$PATH:/sbin:/usr/sbin:$HOME/bin
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
EOS

# mysql の起動・OS 起動時に自動的に起動する
service mysqld start
chkconfig mysqld on

# vagrant user で実行する処理
su - vagrant -c '/bin/bash /vagrant/shell/vagrant-user.sh'

# iptables の停止・OS 起動時に自動的に停止する
service iptables stop
chkconfig iptables off

:
: ----------------------------------------------------
: Completed successfully.
