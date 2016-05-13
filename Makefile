.PHONY: all bash vim emacs
.IGNORE: all bash vim emacs

all : bash vim emacs

bash :
	#if(! -e ~/bin) mkdir ~/bin 
	#if(! -e ~/program) mkdir ~/program
	mkdir ~/bin ~/program
	mv ~/.bashrc ~/ori.bashrc
	cat ~/ori.bashrc my.bashrc > ~/.bashrc
	mv ~/.bash_profile ~/ori.bash_profile
	cat ~/ori.bash_profile my.bash_profile > ~/.bash_profile
	rm ~/ori.bashrc ~/ori.bash_profile

vim :
	mv ~/.vimrc ~/ori.vimrc
	mv ~/.vim ~/ori.vim
	cp my.vimrc ~/.vimrc
	cp -r my.vim ~/.vim

emacs :
	mv ~/.emacs ~/ori.emacs
	mv ~/.emacs.d ~/ori.emacs.d
	cp my.emacs ~/.emacs
	cp -r my.emacs.d ~/.emacs.d
