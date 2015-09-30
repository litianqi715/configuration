sysVim = ~/.vimrc
sysEmacs = ~/.emacs
sysBash = ~/.bashrc
myVim = ./my.vimrc
myEmacs = ./my.emacs
myBash = ./my.bashrc

bash:
	echo "configurating Bash..."
    mv sysBash ~/my.bashrc
    cat myBash ~/my.bashrc > sysBash
    rm ~/my.bashrc
	if [ -f ~/.bash_profile ]; then
		mv ~/.bash_profile ~/my.bash_profile 
		cat ./my.bash_profile ~/my.bash_profile > ~/.bash_profile
		rm ~/my.bash_profile
	else
		cp ./my.bash_profile ~/.bash_profile
	fi
	echo "Bash done!!!"


