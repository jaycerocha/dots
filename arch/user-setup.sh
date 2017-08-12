#!/bin/bash

# Variables used for formatting console output.
bold=$(tput bold)
normal=$(tput sgr0)

# Create tmp folder to download packages.
mkdir ~/tmp/pacaur_install
cd ~/tmp/pacaur_install


# Install "cower" from AUR.
if [ ! -n "$(pacman -Qs cower)" ]; then
  curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
  makepkg PKGBUILD --skippgpcheck --install --needed
fi

# Install "pacaur" from AUR.
if [ ! -n "$(pacman -Qs pacaur)" ]; then
  curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
  makepkg PKGBUILD --install --needed
fi

# Change shell to zsh.
chsh -s /bin/zsh

# Clean up.
cd ~/tmp
rm -r ~/tmp/pacaur_install


# Download key for Raspberry.
read -p "${bold}SSH cert URL: ${normal}" key_url
wget $key_url -o pi
eval $(ssh-agent)
chmod 600 pi
ssh-add pi

# Clone projects folder
read -p "${bold}Raspberry URL: ${normal}" pi_url
git clone --recursive $pi_url:/mnt/data/projects.git ~/projects
cd ~/projects

# Link dots to config folder
~/projects/.dots/link.sh

# Source .zshrc and add remote for Raspberry
source ~/.zshrc
git remote add origin-r $piremote:/mnt/data/projects.git

# Remove .bash_profile so setup isn't executed again.
rm ~/.bash_profile
