#!/bin/sh

myVim="~/.vimrc"
myEmacs="~/.emacs"
myBash="~/.bashrc"

# Vim
echo "configurating Vim..."
if [ -f "$myVim" ]; then
    echo ".vimrc already exists.New configuration file will be appended to .vimrc header!"
    mv "$myVim" my.vimrc
    cat ./my.vimrc ~/my.vimrc >"$myVim"
    rm ~/my.vimrc
else
    mv ./my.vimrc ~/.vimrc
fi
echo "Vim done!!!"

# Emacs
echo "configurating Emacs..."
if [ -f "$myEmacs" ]; then
    echo ".emacs already exists.New configuration file will be appended to .emacs header!"
    mv "$myEmacs" my.emacs
    cat ./my.emacs ~/my.emacs >"$myEmacs"
    rm ~/my.emacs
else
	mv ./my.emacs ~/.emacs
    mv ./my.emacs.d ~/.emacs.d
fi
echo "Emacs done!!!"

# Bash
echo "configurating Bash..."
    mv "$myBash" my.bashrc
    cat ./my.bashrc ~/my.bashrc >"$myBash"
    rm ~/my.bashrc
echo "Bash done!!!"

echo "All done!!!"
