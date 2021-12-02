#!/bin/sh

zsh=$1
kitty=$2
kitty_theme=$3
ulauncher=$4
neofetch=$5
htop=$6

if $zsh
then
	echo 'Installing zsh config'
	rm $HOME/.zshrc
	ln -s $HOME/.dotfiles/zsh/.zshrc $HOME/.zshrc
else
	echo 'Skipping zsh config'
fi

if $kitty
then
	echo 'Installing kitty config'
	rm $HOME/.config/kitty/kitty.conf
	ln -s $HOME/.dotfiles/kitty/kitty.conf $HOME/.config/kitty/kitty.conf
else
	echo 'Skipping kitty config'
fi

if $kitty_theme
then
	echo 'Installing kitty config'
	ln -s $HOME/.dotfiles/kitty/current-theme.conf $HOME/.config/kitty/current-theme.conf
else
	echo 'Skipping kitty-theme config'
fi

if $ulauncher
then
	echo 'Installing ulauncher config'
	rm $HOME/.config/ulauncher/settings.json
	rm $HOME/.config/ulauncher/shortcuts.json
	ln -s $HOME/.dotfiles/ulauncher/settings.json $HOME/.config/ulauncher/settings.json
	ln -s $HOME/.dotfiles/ulauncher/shortcuts.json $HOME/.config/ulauncher/shortcuts.json
else
	echo 'Skipping ulauncher config'
fi

if $neofetch
then
	echo 'Installing neofetch config'
	rm $HOME/.config/neofetch/config.conf
	ln -s $HOME/.dotfiles/neofetch/config.conf $HOME/.config/neofetch/config.conf
else
	echo 'Skipping neofetch config'
fi

if $htop
then
	echo 'Installing htop config'
	rm $HOME/.config/htop/htoprc
	ln -s $HOME/.dotfiles/htop/.config/htop/htoprc $HOME/.config/htop/htoprc
else
	echo 'Skipping htop config'
fi

