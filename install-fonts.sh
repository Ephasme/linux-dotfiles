#!/bin/sh

BASE_URL=https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts
NAME=Fira\ Code\ Nerd\ Font\ Complete.ttf
URL=$BASE_URL/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf

## Install font
rm -rf ~/.fonts
mkdir -p ~/.fonts
curl -fLo "$NAME" $URL
mv -f "$NAME" ~/.fonts
fc-cache -f

