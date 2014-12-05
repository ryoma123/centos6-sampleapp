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

sudo yum -y install "${packages[@]}"

# gem インストール時にドキュメントを保存しない
cat <<'EOS' > /home/vagrant/.gemrc
gem: --no-ri --no-rdoc
EOS

# rbenv を clone する
if [ -d /home/vagrant/.rbenv ]; then
    :
    : rbenv already installed
else
    git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
fi

# bash_profile にrbenv のパスを保存する
cat <<'EOS' > /home/vagrant/.bash_profile
[ -f ~/.bashrc ] && . ~/.bashrc
export PATH=$PATH:/sbin:/usr/sbin:$HOME/bin
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
EOS

set +u
source /home/vagrant/.bash_profile
set -u

# mysql の起動・OS 起動時に自動的に起動する
sudo service mysqld start
sudo chkconfig mysqld on

# ruby-build を clone する
if [ -d /home/vagrant/.rbenv/plugins/ruby-build ]; then
    :
    : ruby-build already installed
else
    git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
fi

# ruby 2.1.5 のインストール
if [ -d /home/vagrant/.rbenv/versions/2.1.5 ]; then
    :
    : ruby 2.1.5 already installed
else
    MAKEOPTS="-j4" CONFIGURE_OPTS="--disable-install-doc" rbenv install 2.1.5
    rbenv global 2.1.5
    rbenv rehash
fi

# rails アプリを clone する
if [ -d /home/vagrant/sample_app2 ]; then
    :
    : sample_app2 already installed
else
    git clone -b gemfile-for-centos6 https://github.com/ryoma123/sample_app2.git /home/vagrant/sample_app2
fi

# bundler のインストール
if [ -f /home/vagrant/.rbenv/shims/bundler ]; then
    :
    : bundler already installed
else
    gem install bundler
fi

# bundler の実行
cd /home/vagrant/sample_app2

if [ -d /home/vagrant/sample_app2/vendor/bundle ]; then
    :
    : gem already installed
else
    bundle install --deployment
fi

# DB の生成
bundle exec rake db:create RAILS_ENV=production
bundle exec rake db:migrate RAILS_ENV=production

# assets:precompile の実行
bundle exec rake assets:precompile RAILS_ENV=production

# iptables の停止・OS 起動時に自動的に停止する
sudo service iptables stop
sudo chkconfig iptables off

:
: ----------------------------------------------------
: Completed successfully.
