"colorscheme torte
"colorscheme murphy
"colorscheme desert 
"colorscheme desert 
"colorscheme elflord
colorscheme ron
filetype plugin on
""let g:FlymakerOn = 1
" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/code-complete-tags
" set tags+=~/.vim/tags/gl
" set tags+=~/.vim/tags/sdl
" set tags+=~/.vim/tags/qt4
" build tags of your own project with Ctrl-F12
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

""""""""""""""""""""""""""""""""""""""""""""""
" code auto-complete
"
""""""""""""""""""""""""""""""""""""""""""""""

set number
syntax on           " 语法高亮  
"打开文件类型检测, 加了这句才可以用智能补全
filetype plugin indent on 
" 为特定文件类型载入相关缩进文件
filetype indent on
" 侦测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 增强模式中的命令行自动完成操作
set wildmenu
"自动补全
:inoremap ( ()<ESC>i
:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
"":inoremap { {}<ESC>i<CR><ESC>V<O
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
:inoremap " ""<ESC>i
:inoremap ' ''<ESC>i
"":inoremap < <><ESC>i
"":inoremap > <c-r>=ClosePair('>')<CR>
function! ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endfunction

function! RemovePairs()
	let l:line = getline('.')
	let l:previous_char = l:line[col('.')-1] "character before current one

	if index(['(','[','{'],l:previous_char) != -1
		let l:original_pos = getpos('.')
		execute "normal %"
		let l:new_pos = getpos('.')

		" no corresponding Right parencheses
		if l:original_pos == l:new_pos
			execute "normal! a\<BS>"
			return
		endif

		let l:line2 = getline('.')
		if len(l:line2) == col('.')
			"if right parenthese is last character of current line
			execute "normal! v%xa"
		else
			"if not then
			execute "normal! v%xi"
		endif
	else
		execute "normal! a\<BS>"
	endif
endfunction
" 删除左括号时同时删除右括号
:inoremap <BS> <ESC>:call RemovePairs()<CR>a

" taglist requirement when vim used in console
"代码补全 
set completeopt=preview,menu 
""set completeopt=longest,menu
" 自动缩进
set autoindent
" 为C程序提供自动缩进
set smartindent
set cindent
" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2
" Tab键的宽度
set tabstop=4
" 统一缩进为4
set softtabstop=4
set shiftwidth=4
" 不要用空格代替制表符
set noexpandtab
" 在行和段开始处使用制表符
set smarttab
set foldenable      " 允许折叠  
set foldcolumn=0
""set foldmethod=indent 
set foldmethod=manual   " 手动折叠  
set foldlevel=3 

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 新文件标题
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"新建.c,.h,.sh,.java文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
	"如果文件类型为.sh文件 
	if &filetype == 'sh' 
		call setline(1,"\#########################################################################") 
		call append(line("."), "\# File Name: ".expand("%")) 
		call append(line(".")+1, "\# Author: litianqi") 
		call append(line(".")+2, "\# mail: litianqi@litianqi.org") 
		call append(line(".")+3, "\# Created Time: ".strftime("%c")) 
		call append(line(".")+4, "\#########################################################################") 
		call append(line(".")+5, "\#!/bin/bash") 
		call append(line(".")+6, "") 
	endif
	if &filetype == 'cpp'
		call setline(1,"\// ".expand("%")." -- ") 
		call append(line("."), "\// Author: litianqi") 
		call append(line(".")+1, "\// Author: litianqi@litianqi.org")
		call append(line(".")+2, "\// Visit http://litianqi.org")
		call append(line(".")+3, "\// Created Time: ".strftime("%c"))
		call append(line(".")+4, "\#include <iostream>") 
		call append(line(".")+5, "using namespace std;")
		call append(line(".")+6, "int main () {")
		call append(line(".")+7, "}")
	endif
	if &filetype == 'c'
		call setline(1,"\// ".expand("%")." -- ") 
		call append(line("."), "\// Author: litianqi") 
		call append(line(".")+1, "\// Author: litianqi@litianqi.org")
		call append(line(".")+2, "\// Visit http://litianqi.org")
		call append(line(".")+3, "\// Created Time: ".strftime("%c"))
		call append(line(".")+4, "#include<stdio.h>")
		call append(line(".")+5, "int main () {")
		call append(line(".")+6, "}")
	endif
	if &filetype == 'java'
		call setline(1, "/**") 
		call append(line("."), " * File Name: ".expand("%")) 
		call append(line(".")+1, " * Created Time: ".strftime("%c")) 
		call append(line(".")+2, " * @author litianqi") 
		call append(line(".")+3, " * @author http://litianqi.org ") 
		call append(line(".")+4, " * @author litianqi@litianqi.org ") 
		call append(line(".")+5, " * @version 1.0 ") 
		call append(line(".")+6, "*/") 
		call append(line(".")+7, "")
		call append(line(".")+8, "package org.litianqi.java;")
		call append(line(".")+9, "")
		call append(line(".")+10,"public class {}")
	endif
	"新建文件后，自动定位到文件末尾
	autocmd BufNewFile * normal G
endfunc 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"键盘命令
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" modify window size
nmap <C-H> <C-W>< 
nmap <C-L> <C-W>>
nmap <C-K> <C-W>+
nmap <C-J> <C-W>-
"去空行  
nnoremap <F2> :g/^\s*$/d<CR> 
"比较文件  
nnoremap <C-F2> :vert diffsplit 
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "! ./%<"
	elseif &filetype == 'cpp'
		exec "!g++ % -o %<"
		exec "! ./%<"
	elseif &filetype == 'java' 
		exec "!javac %" 
		exec "!java %<"
	elseif &filetype == 'sh'
		:!./%
	elseif &filetype == 'py'
		exec "!python %"
		exec "!python %<"
	elseif &filetype == 'pl'
		exec "!perl %"
		exec "!perl %<"
	endif
endfunc
"C,C++的调试
map <F8> :call Rungdb()<CR>
func! Rungdb()
	exec "w"
	exec "!g++ % -g -o %<"
	exec "!gdb ./%<"
endfunc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示相关  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showcmd         " 输入的命令显示出来，看的清楚些  
set scrolloff=3     " 光标移动到buffer的顶部和底部时保持3行距离  
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   "状态行显示的内容  
set ruler                   " 打开状态栏标尺
set magic                   " 设置魔术
set guioptions-=T           " 隐藏工具栏
set guioptions-=m           " 隐藏菜单栏
set nocompatible  "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限  
" 显示中文帮助
if version >= 603
	set helplang=cn
	set encoding=utf-8
endif
"编码设置
set enc=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
"语言设置
set langmenu=zh_CN.UTF-8
set helplang=cn
" 在处理未保存或只读文件的时候，弹出确认
set confirm
"set statusline=[%F]%y%r%m%*%=[Line:%l/%L,Column:%c][%p%%]
" 总是显示状态行
set laststatus=2
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
" 字符间插入的像素行数目
set linespace=0
" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l
" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\
" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3
" 高亮显示普通txt文件（需要txt.vim脚本）
au BufRead,BufNewFile *  setfiletype txt
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 实用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 设置当文件被改动时自动载入
set autoread
" quickfix模式
autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>
"共享剪贴板  
set clipboard+=unnamed 
"从不备份  
set nobackup
"自动保存
set autowrite
" 不要使用vi的键盘模式，而是vim自己的
set nocompatible
" 去掉输入错误的提示声音
set noeb
" 历史记录数
set history=1000
"禁止生成临时文件
set nobackup
set noswapfile
"搜索忽略大小写
set ignorecase
"搜索逐字符高亮
set hlsearch
set incsearch
"行内替换
set gdefault
" 命令行（在状态行下）的高度，默认为1，这里是2
set cmdheight=2
" 保存全局变量
set viminfo+=!
" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
""set mouse=a
""set selection=exclusive
""set selectmode=mouse,key
" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0

"NERDtee设定
let NERDChristmasTree=1
let NERDTreeAutoCenter=1
let NERDTreeBookmarksFile=$VIM.'\Data\NerdBookmarks.txt'
let NERDTreeMouseMode=2
let NERDTreeShowBookmarks=1
let NERDTreeShowFiles=1
let NERDTreeShowHidden=1
let NERDTreeShowLineNumbers=1
let NERDTreeWinPos='left'
let NERDTreeWinSize=31
nnoremap f :NERDTreeToggle
map <F7> :NERDTree<CR>  
