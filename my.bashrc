# personal functions
function mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\""; }
shopt -s cdspell
function rm () { mv "$@" ~/todel; }
function rml () { rm "$@" && eval ls; }
function cl () { cd "$@" && eval ls; }
function gaa () { g++ $1 -o $2; }
function show () { cat -n "$@" | less ; }
function showStore () { du -h --max-depth=1; }
function showDir () { ll -h | grep -e "drw"; }
function calFields () { head -1 "$@" | grep -o -e ' ' -e '\t' | wc -l; }
function e () { exit; }
function t () { top M; }
function ap () { pwd >> ~/.bash_profile; }
function store () { chmod -R 544 *; }
function cross () { screen wine ~/freegate/fg742p.exe ; }
function ar () { pwd >>~/.bashrc; }
function resources () { (echo -e pid "\t" comm "\t" args "\t" pcpu "\t" rsz "\t" vsz "\t" stime "\t" user "\t" uid && (ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid'|grep "$1" |sort -nrk5)) |less; }
alias big5="find . -type f | ls -s |sort -n -r | head -5"
alias py="python3"
alias k="clear"
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias cmacs="emacs -nw"
alias a="cmacs"
alias time="/usr/bin/time"

export NF=211.64.140.208
export NS=211.64.140.209
export NT=211.64.140.210

