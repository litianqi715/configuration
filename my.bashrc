# personal functions
function mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\""; }
shopt -s cdspell
function rml () { rm "$@" && eval ls; }
function cl () { cd "$@" && eval ls; }
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias cmacs="emacs -nw"
alias ltq="cmacs"
PATH=$PATH:~/program/jre1.7.0_45/bin
PATH=$PATH:~/bin
