#!/usr/bin/env bash
sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get install -y git git-core curl


#INSTALAÇÃO RUBY ON RAILS
#https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-14-04
#https://gorails.com/setup/ubuntu/14.10
sudo apt-get install -y zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev

cd
git clone git://github.com/sstephenson/rbenv.git .rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

rbenv install -v 2.3.0
rbenv global 2.3.0

gem install bundler

gem install rails

rbenv rehash

sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get -y update
sudo apt-get -y install nodejs


#INSTALAÇÃO POSTGRES
sudo apt-get install -y postgresql-common
sudo apt-get install -y postgresql libpq-dev

