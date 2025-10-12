colo wildcharm
set ai rnu shcf=-ic et shiftwidth=4 ts=4 bg=dark acd ar cul tm=100
sy on   |   no ; :
set mp=g++\ -Wall\ -Wconversion\ -Wshadow\ -Wfatal-errors\ -DLOCAL\ -g\ -std=c++20\ -fsanitize=undefined,address\ -I$HOME/github.com/competitive-programming/.template\ -Winvalid-pch\ %:r.cpp

ca Hash w !cpp -dD -P -fpreprocessed \| tr -d '[:space:]' \
 \| md5sum \| cut -c-6
   



" local
" no ; :
" no : ;
imap <C-c> ;

auto BufNewFile *.cpp   0r $HOME/github.com/competitive-programming/.template/template.cpp   
"" hi MatchParen  term=reverse cterm=bold ctermfg=199 ctermbg=NONE gui=bold guifg=#ff00af
"" hi Cursorline  term=underline cterm=NONE ctermbg=235 guibg=#262626
"" hi Statement   term=bold ctermfg=39 guifg=#00afff
"" hi PreProc     term=underline ctermfg=44 guifg=#00d7d7
"" hi link        Character   Constant
"" hi link        Number      Constant
"" hi link        Boolean     Constant
"" hi link        Float       Number
"" hi link        Function    Identifier
"" hi link        Conditional Statement
"" hi link        Repeat      Statement
"" hi link        Label       Statement
"" hi link        Operator    Statement
"" hi link        Keyword     Statement
"" hi link        Exception   Statement
"" hi link        Include     PreProc
"" hi link        Define      PreProc
"" hi link        Macro       PreProc
"" hi link        PreCondit   PreProc

""     \|  silent execute 'read !date'
""     \|  s/^/\/\/\ /

call plug#begin()
"" 
    "" Plug 'dylanaraps/wal.vim'
    Plug 'tribela/vim-transparent'
call plug#end()
