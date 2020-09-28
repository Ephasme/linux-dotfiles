#!/bin/sh

DOTFILES_DIR=$HOME/.dotfiles
ONE_PASSWORD_VERSION=v1.7.0

TMP_DIR=$DOTFILES_DIR/.tmp
CONFIG_DIR=$DOTFILES_DIR/config

alias install="sudo apt-get install -y"

## Generic stuff
# creates a temporary directory for downloads and stuff...
rm -rf $TMP_DIR && mkdir $TMP_DIR

# updates the repositories and binaries
sudo apt-get update -y && \
   sudo apt-get upgrade -y && \
   sudo add-apt-repository universe

install xclip xsel # to copy to system clipboard in tmux

## One Password cli
# wget -O $TMP_DIR https://cache.agilebits.com/dist/1P/op/pkg/$ONE_PASSWORD_VERSION/op_linux_amd64_$ONE_PASSWORD_VERSION.zip
# unzip $TMP_DIR/op_linux_amd64_$ONE_PASWORD_VERSION.zip $TMP_DIR

# Install vpn
install openvpn \
    network-manager-openvpn \
    network-manager-openvpn-gnome

# Install fonts
cat $DOTFILES_DIR/install-fonts.sh | /bin/bash 

## install fnm
curl -fsSL "https://github.com/Schniz/fnm/raw/master/.ci/install.sh --skip-shell" | bash
$HOME/.fnm/fnm install latest
ln -sf $DOTFILES_DIR/npmrc $HOME/.npmrc

## Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn

## Git
install git
git submodule update --init --recursive --remote

make_key() {
    echo "generating keys..."
    [ ! -f "$HOME/.ssh/$2" ] && ssh-keygen -q -t rsa -b 4096 -C "$1" -f "$HOME/.ssh/$2" -N ""
}
make_key "loup@foxintelligence.fr" "work_id_rsa"
make_key "loup.peluso@gmail.com"   "me_id_rsa"
ln -sf "$DOTFILES_DIR/ssh-config" "$HOME/.ssh/config"

## ZSH
install zsh
chsh -s $(which zsh)
ln -nsf $DOTFILES_DIR/oh-my-zsh ~/.oh-my-zsh
ln -sf $DOTFILES_DIR/zshrc ~/.zshrc

## tmux
install tmux
# oh my tmux
ln -sf $DOTFILES_DIR/oh-my-tmux/.tmux.conf   ~/.tmux.conf
ln -sf $DOTFILES_DIR/tmux.conf.local         ~/.tmux.conf.local

## NeoVim
install neovim
mkdir -f ~/.config/nvim 2>/dev/null
ln -sf $CONFIG_DIR/nvim/init.vim ~/.config/nvim/init.vim
mkdir -f ~/.config/nvim/themes 2>/dev/null
ln -sf $CONFIG_DIR/nvim/themes/onedark.vim ~/.config/nvim/themes/onedark.vim
mkdir -f ~/.config/coc 2>/dev/null
ln -sf $CONFIG_DIR/coc/coc-settings.json ~/.config/coc/coc-settings.json

## Kitty terminal
install kitty
mkdir -p .config/kitty 2>/dev/null
ln -sf $CONFIG_DIR/kitty/kitty.conf ~/.config/kitty/kitty.conf
ln -sf $CONFIG_DIR/kitty/kitty-themes/themes/OneDark.conf ~/.config/kitty/theme.conf

## Github cli
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt update
install gh


## Awesome WM
install awesome

## installation of google chrome
sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sudo apt-get update -y
install google-chrome-stable -y

## Snaps
sudo snap install slack --classic

# remove the tmp
rm -rf $TMP_DIR

