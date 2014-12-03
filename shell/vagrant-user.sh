#!/bin/bash

set -x
set -e
set -u

PATH=/bin:/sbin:/usr/bin:/usr/sbin

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
    bundle update guard
    bundle install --path vendor/bundle
fi

# DB の生成
bundle exec rake db:migrate RAILS_ENV=production

# assets:precompile の実行
bundle exec rake assets:precompile RAILS_ENV=production
