" Vim plugin for Linux man 2, 3 and GTags-powered prototype completion.
"        Author: Sylvain Saubier (ResponSyS), saubiersylvain@gmail.com
"       Version: 0.5
" Last Modified: 140522 
"       License: CC0
"
" This script comes with the help file  doc/gtags-and-man-proto.txt .
"
" TODO
" * gmh : only display hint of curr func in statusline even if in completion mode
" * hints for the type of the function
" * remove non-keyword words in completion mode:
"       myFunc ( {+int_datIntLel+} )    /* not removed */
"       myFunc ( {+int+} )              /* removed */
" * using da @g register is not so neat bro
"   * but is nice ta yank da prototype dat way ya know lel
" * improve compatibility with Java, PHP and such
""""""""""""""""""""""""""""""""""""""""""""""""

"
" 1 : Turn off GAMP
" Also prevents duplicate loading
"
if exists ( "g:loaded_GAMP" ) || &compatible == 1
    finish
    en
let g:loaded_GAMP = 1

"
" 1 : Turn off GTags lookup
"
if !exists ( "g:GAMP_GTagsOff" )
    let g:GAMP_GtagsOff = 0
    en

"
" 1 : completion mode
" 2 : statusline mode
" 3 : completion and statusline modes
"
if !exists ( "g:GAMP_Mode" )
    let g:GAMP_Mode = 2
    en


"
" String inserted between the function name and the parenthesis
" (defaults to a space char)
"
if !exists ( "g:GAMP_CharAfterFn" )
    let g:GAMP_CharAfterFn = ' '
    en

"
" 1 : put inner spaces around function parenthesis
" Example:      func( int there_are_2_spaces_around_us )
"
if !exists ( "g:GAMP_SpaceAroundArgs" )
    let g:GAMP_SpaceAroundArgs = 1
    en

"
" 1 : buffer opened to look for function prototype with GTags is deleted
"
if !exists ( "g:GAMP_UnloadLoadedBuffer" )
    let g:GAMP_UnloadLoadedBuffer = 0
    en

"
" String for the statusline format on the right of the prototype
" when prototype is displayed
"
if !exists ( "g:GAMP_StatusLineFmt" )
    let g:GAMP_StatusLineFmt = "%=%l,%c    %f%m%h"
    en

"
" Taken from gtags.vim
" Character to use to quote patterns and file names before passing to global.
" (This code was drived from 'grep.vim'.)
"
if !exists ( "g:GAMP_Shell_Quote_Char" )
    if has ( "win32" ) || has ( "win16" ) || has ( "win95" )
        let g:GAMP_Shell_Quote_Char = '"'
    else
        let g:GAMP_Shell_Quote_Char = "'"
        en
    en

if &laststatus != 2
    set laststatus=2
    echo "GAMP set laststatus to 2 ( mandatory )"
    echo "If you want to avoid this message add:\n set laststatus=2\nto your VIMRC in " . $VIM
    en

" 
" Retrieve default statusline format
let s:statusline_orig = &statusline
"
" If 0 means statusline hint is enabled
" If 1 means statusline hint is disabled
let s:statusline_status = 0
let s:statusline_last = ""

"
" Taken from gtags.vim
" global command name
"
let s:global_command = $GTAGSGLOBAL
if s:global_command == ''
    let s:global_command = "global"
    en

"
" Forked from s:Error in gtags.vim
" Display error message.
"
function! s:F_PrintError (s_msg)
    let l:s_msg = substitute ( a:s_msg, '[\n\r]', "", 'g' )
    echoerr "GAMP: " . l:s_msg
endfunction

"
" Adds spaces between prototype arguments
"
function! s:F_ParseProtoSpace ( s_proto )
    return substitute (a:s_proto, ",", ", ", 'g')
endf

"
" Removes extra spaces and newlines
"
function! s:F_ParseProtoGlobal ( s_proto )
    let l:s_protoNew = substitute (a:s_proto, '[\n\r]', "", 'g' )
    let l:s_protoNew = substitute (l:s_protoNew, '\s\+', " ", 'g')
    return s:F_ParseProtoSpace ( l:s_protoNew )
endf

"
" Crops function to args with parenthesis
"
function! s:F_ParseProtoCrop ( s_proto )
    let l:s_protoNew = substitute ( a:s_proto, ").*$", ")", '' )
    let l:s_protoNew = substitute ( l:s_protoNew, "^.*(", "(", '' )
    return s:F_ParseProtoSpace ( l:s_protoNew )
endf

"
" Adds jumps to prototype
"
function! s:F_AddJumpsProto ( s_proto )
    let l:s_protoNew = substitute ( a:s_proto, '*', "_pt_", 'g' )
    let l:s_protoNew = substitute ( l:s_protoNew, "[.][.][.]", "VA_Args", 'g' )
    let l:s_protoNew = substitute ( l:s_protoNew, "^(", "({+", '' )
    let l:s_protoNew = substitute ( l:s_protoNew, ")$", "+})", '' )
    let l:s_protoNew = substitute ( l:s_protoNew, ",  ", "+},{+", 'g' )
    let l:s_protoNew = substitute ( l:s_protoNew, " ", "_", 'g' )
    let l:s_protoNew = substitute ( l:s_protoNew, "[\\[\\]]", "_", 'g' )
    if g:GAMP_SpaceAroundArgs == 1
        let l:s_protoNew = substitute ( l:s_protoNew, "^(", "( ", '' )
        let l:s_protoNew = substitute ( l:s_protoNew, ")$", " )", '' )
        en
    return substitute ( l:s_protoNew, ",", ", ", 'g' )
endf

"
" Returns retrieved prototype from man(1) section 2
" Returns -1 on error
"
function! s:F_ProtoLookupMan2 ( pattern )
    let l:cmd = "man 2 " . a:pattern . " | grep '" . a:pattern . "(' | head -1"
    let l:man2_result = system ( "man 2 " . a:pattern . " > /dev/null")

    if v:shell_error != 0                   " If man 2 fails
        let s:s_error = l:man2_result
        return -1
    else
        return s:F_ParseProtoCrop ( system ( l:cmd ) )
        en
endf

"
" Returns retrieved prototype from man(1) section 3
" Returns -1 on error
"
function! s:F_ProtoLookupMan3 ( pattern )
    let l:cmd = "man 3 " . a:pattern . " | grep '" . a:pattern . "(' | head -1"
    let l:man3_result = system ( "man 3 " . a:pattern . " > /dev/null")

    if v:shell_error != 0                   " If man 3 fails
        let s:s_error = l:man3_result
        return -1
    else
        return s:F_ParseProtoCrop ( system ( l:cmd ) )
        en
endf

"
" Forked from s:ExecLoad in gtags.vim
" Returns retrieved prototype from global(1)
"
function! s:F_ProtoLookupGlobal ( pattern )
    if g:GAMP_GTagsOff == 1
        let s:s_error = ''
        return -1
        en
    let l:gtags_result = "ctags-mod"
    let l:gtags_efm = "%f\t%l\t%m"
    let l:global_option = '--result=' . l:gtags_result . ' -q'

    let l:global_result = ''
    let l:cmd = s:global_command . ' ' . l:global_option . ' ' . g:GAMP_Shell_Quote_Char . a:pattern . g:GAMP_Shell_Quote_Char 
"   echo "Global command:   " l:cmd

    let l:global_result = system(l:cmd)
    if v:shell_error != 0
        if v:shell_error != 0
            if v:shell_error == 2
                let s:s_error = "invalid arguments. please use the latest GLOBAL."
            elseif v:shell_error == 3
                let s:s_error = "GTAGS not found."
            else
                let s:s_error = "global command failed. command line: " . l:cmd
                en
            en
        return -1
        en

    if l:global_result == '' 
        let s:s_error = "Tag which matches to " . g:GAMP_Shell_Quote_Char . a:pattern . g:GAMP_Shell_Quote_Char . " not found."
        return -1
        en

    sp                              " Open split window
    let l:efm = &errorformat        " Go to function definition using QuickFix jump
    let &errorformat = l:gtags_efm
    cexpr! l:global_result
    let &errorformat = l:efm

    call search ('(', 'e')
    let l:reg_g = @g
    let l:reg_quote = @"            " Yank function prototype in @g register
    exe 'norm v%"gy'
    let l:protoUnparsed = @g        " Store register @g in a var
    let @g = l:reg_g                " Give back initial values to registers
    let @" = l:reg_quote

    if g:GAMP_UnloadLoadedBuffer == 1
        bdelete
    else
        q
        en

    return s:F_ParseProtoGlobal ( l:protoUnparsed )
endfunction

"
" Returns prototype string to be inserted
" In statusline mode, returns empty
" On error, returns empty
" Change statusline when needed
"
function! s:F_GetProto ()
    let s:s_errorFull = ''
    let l:line_curr     = getline   ('.')
    let l:column_curr   = col       ('.')
    let l:char_curs     = l:line_curr[ l:column_curr - 1 ]
    let l:char_curs_next= l:line_curr[ l:column_curr ]
    "
    " Get on last letter of the function to complete (assuming cursor is after or anywhere on word)
    if match (l:char_curs, '\w') != -1                                  " if cursor on word char
        if g:GAMP_Mode != 2 && match (l:char_curs_next, '\w') != -1  " if letter after cursor is a word char and if not statusline mode
            " we can go to end of word using e
            exe "norm e"
        " else
            " means we're already at the end of the word, so do not move
            en
    else
        norm gE
        while match ( getline ('.')[ col ('.') - 1 ] , '\W') != -1 ||  char2nr (getline ('.')[ col ('.') - 1 ]) == 0
        " while cursor not on word char or cursor on NUL char
            " get back to last letter of prev word
            norm gE
            endw
        en
    let s:func_name = expand ( "<cword>" )          " now on the last letter of word to complete

    let l:func_args = s:F_ProtoLookupMan3 ( s:func_name )
    if  l:func_args == -1                           " if func not known to man 3
        let s:s_errorFull = s:s_error . "; "
        let l:func_args = s:F_ProtoLookupMan2 ( s:func_name )
        if l:func_args == -1                            " if func not known to man 2
            let s:s_errorFull = s:s_errorFull . s:s_error . "; "
            let l:func_args = s:F_ProtoLookupGlobal ( s:func_name )
            if  l:func_args == -1                           " if func not known to GTags
                let s:s_errorFull = s:s_errorFull . s:s_error
                call s:F_PrintError ( s:s_errorFull )
                return ""
                en
            en
        en
    
    if g:GAMP_Mode == 2 || g:GAMP_Mode == 3
        let &statusline = "%#Search#" . s:func_name . ' ' . l:func_args . "%#None#" . g:GAMP_StatusLineFmt
        let s:statusline_last = &statusline | let s:statusline_status = 1
        en
    if g:GAMP_Mode == 1 || g:GAMP_Mode == 3
        let l:func_args = s:F_AddJumpsProto ( l:func_args )
        return g:GAMP_CharAfterFn . l:func_args
    else
        return ""
        en
endfunction

"
" To put or not to put, that is the question
"
function! s:F_GtagsAndManCompl (  )
"   let l:n_line = line ('.')
"   let l:n_col  = col  ('.') - 1

    " This method replace ONLY the first occurence of func_name in the
    " line !!!
    let l:s_proto = s:F_GetProto (  )
    if  l:s_proto != ""
        call setline ( '.', substitute ( getline( '.' ), s:func_name, s:func_name . l:s_proto, 'g' ) )
        en
    unlet s:func_name

"   let l:reg_quote = @"
"   let l:reg_g = @g
"   let @g = s:F_GetProto (  )
"   if @g != ""
"       exe 'norm "gp'
"       en
"   let @g = l:reg_g
"   let @" = l:reg_quote

"   call setpos ( '.',[ 0, n_line, n_col, 0 ] )
endf

"
" Put GAMP in statusline mode, process completion and get back to
" original mode
"
function! s:F_GtagsAndManHintOnly (  )
    let l:n_modePrev = g:GAMP_Mode
    let g:GAMP_Mode = 2
    call s:F_GtagsAndManCompl (  )
    let g:GAMP_Mode = l:n_modePrev
endf

"
" Toggle statusline value
"
function! s:F_StatusLineToggle ( status )
    if a:status == 0 || s:statusline_status == 1
        let &statusline = s:statusline_orig
        let s:statusline_status = 0
    elseif a:status == 1 || s:statusline_status == 0
        let &statusline = s:statusline_last
        let s:statusline_status = 1
        en
    if a:status == -1
        echo "GAMP: statusline toggled."
        en
endfunction

"
" Mappings and commands
"
if has ( "autocmd" ) && !exists ( "s:GAMP_Autocmd" )
    let s:GAMP_Autocmd = 1
    autocmd InsertLeave,BufWritePost *    call <SID>F_StatusLineToggle (0)
    en
command!                    GAMPStatusLineToggle    call <SID>F_StatusLineToggle(-1)
nmap     <unique> <silent>  gmt                     :call <SID>F_StatusLineToggle(-1)<CR>
command!                    GAMPComplete            call <SID>F_GtagsAndManCompl()
nmap     <unique> <silent>  gmc                     :call <SID>F_GtagsAndManCompl()<CR>
nmap     <unique> <silent>  gmh                     :call <SID>F_GtagsAndManHintOnly()<CR>
inoremap <unique> <silent>  <Leader>gm              <Esc>:call <SID>F_GtagsAndManCompl()<CR>i
nnoremap <unique> <silent>  <Leader>gm              :call <SID>F_GtagsAndManCompl()<CR>

