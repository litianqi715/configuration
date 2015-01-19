#!/usr/bin/env bash

myVim="~/.vimrc"
myEmacs="~/.emacs"
myBash="~/.bashrc"

# Bash
echo "configurating Bash..."
    mv ~/.bashrc ~/my.bashrc
    cat ./my.bashrc ~/my.bashrc > ~/.bashrc
    rm ~/my.bashrc
	if [ -f ~/.bash_profile ]; then
		mv ~/.bash_profile ~/my.bash_profile 
		cat ./my.bash_profile ~/my.bash_profile > ~/.bash_profile
		rm ~/my.bash_profile
	else
		cp ./my.bash_profile ~/.bash_profile
	fi
echo "Bash done!!!"

# Vim
echo "configurating Vim..."
if [ -f "$myVim" ]; then
    echo ".vimrc already exists.New configuration file will be appended to .vimrc header!"
    mv $myVim my.vimrc
    cat ./my.vimrc ~/my.vimrc >"$myVim"
    rm ~/my.vimrc
else
    cp ./my.vimrc ~/.vimrc
	cp -r ./my.vim ~/.vim
fi
echo "Vim done!!!"

# Emacs
echo "configurating Emacs..."
if [ -f "$myEmacs" ]; then
    echo ".emacs already exists.New configuration file will be appended to .emacs header!"
    mv $myEmacs my.emacs
    cat ./my.emacs ~/my.emacs >"$myEmacs"
    rm ~/my.emacs
else
	cp ./my.emacs ~/.emacs
    cp -r ./my.emacs.d ~/.emacs.d
fi
echo "Emacs done!!!"


echo "All done!!!"
