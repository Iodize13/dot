set belloff=all shiftwidth=4 ai tm=100 ts=4

sy on

" match nvim: gruvbox, dark, truecolor (t_8f/t_8b needed under tmux)
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors background=dark
silent! colorscheme wildcharm

set nofsync swapsync=          " don't block on journal commits
set directory=/dev/shm//       " swapfile in RAM, not next to the source

set clipboard=unnamedplus


autocmd BufNewFile *.cpp 0r ~/github.com/Iodize13/competitive-programming/.template/cftemplate.cpp | 12 | startinsert
