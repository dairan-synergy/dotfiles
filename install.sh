#!/usr/bin/env bash

#thanks for https://github.com/holman/dotfiles

cd "$(dirname "$0")/."
DOTFILES_ROOT=$(pwd -P)

#causes the shell to exit if any subcommand or pipeline returns a non-zero status.
set -e

echo ''

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  #for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  #do
  #  dst="$HOME/.$(basename "${src%.*}")"
  #  link_file "$src" "$dst"
  #done

  link_file $DOTFILES_ROOT/bashrc $HOME/.bashrc
}

if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Installing dotfiles for the first time"
    git clone --depth=1 https://github.com/dairan-synergy/dotfiles.git "$HOME/.dotfiles"
    #cd "$HOME/.yadr"
    #[ "$1" = "ask" ] && export ASK="true"
    #rake install
else
    echo "dotfiles is already installed"
    exit 0
fi

sudo apt-get update -qq
sudo apt-get -y upgrade
sudo apt-get -y autoremove

sudo apt-get install -y git git-core curl


#INSTALAÇÃO POSTGRES
sudo apt-get install -y postgresql-common
sudo apt-get install -y postgresql libpq-dev


#INSTALAÇÃO RUBY ON RAILS
#https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-14-04
#https://gorails.com/setup/ubuntu/14.10
sudo apt-get install -y zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev apt-utils

if [ ! -d "$HOME/.rbenv" ]; then
    echo "Installing rbenv for the first time"

    curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.15.0/install.sh | sudo -E bash -
    source ~/.nvm/nvm.sh
    nvm install 0.10
    #sudo apt-get install -y nodejs

    cd
    git clone git://github.com/sstephenson/rbenv.git .rbenv
    git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

    install_dotfiles
    source $HOME/.bashrc

    rbenv install -v 2.3.0
    rbenv global 2.3.0

    gem install bundler

    gem install rails

    rbenv rehash
fi

#DOCKER
curl -fsSL https://get.docker.com/ | sh
curl -fsSL https://get.docker.com/gpg | sudo apt-key add -
sudo usermod -aG docker ubuntu
#sudo apt-get -y install apt-transport-https ca-certificates
#sudo apt-key -y adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#sudo apt-get -y update
#sudo apt-get -y purge lxc-docker
#sudo apt-cache -y policy docker-engine
#sudo apt-get -y update
#sudo apt-get -y install linux-image-extra-$(uname -r)
#sudo apt-get -y install apparmor
#sudo apt-get -y install docker-engine
#sudo service docker start

sudo sh -c "curl -sL https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
sudo chmod +x /usr/local/bin/docker-compose

echo ''
echo '  All installed!'
