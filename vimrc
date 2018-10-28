set nocompatible
" 2015-06-09 because it chokes soo much

set guifont=DejaVu\ Sans\ Mono\ 8
set shiftwidth=4 tabstop=4 noexpandtab

" 2015-07-25 keep 3 lines away from our cursor onscreen at all times
set scrolloff=3

syntax on

" 2014-06-29 added n for wrapping of №  lists
set formatoptions=croqln

"bah, need to get this working
"comments=://,bn:>

" 2015-06-09 stop .netrwhist appearing
let g:netrw_dirhistmax = 0

" 2015-06-09 resolve issues with backspace at times
set backspace=start,eol,indent

" 2015-08-02 because the default suggests the devs are monsters
set nojoinspaces

" 2015-08-02 make our vim yank onto the system cut buffer (+)
" TODO possibly move into the gui tested block + verify on OSX
set clipboard=unnamedplus,exclude:cons\|linux

" 2015-04-04 trying to get Thanks for flying Vim out of my sight
set titleold=
if !has("gui_running")
	if &term == "xterm" && &t_ts == ""
		let &t_ts = "\e]2;"
	endif
	if &t_ts != ""
		set title titlestring=%t%m\ -\ vim
	endif
endif

" 2015-07-30 pick a random colour scheme to start
if has("gui_running")
	set background=light
	colorscheme default
endif
if !has("gui_running")
	set background=dark
	" 2015-08-24 TODO osx does not have slate, find replacement :(
	colorscheme slate
endif

" 2014-02 adding some sugar
set listchars=tab:⇢ ,trail:⌁,eol:⌞,extends:↦,precedes:⌇,nbsp:⌅
"set list
noremap <F12> :set list!<CR>
set cursorline

" 2015-07-20 toggle cursorline
noremap <F9> :set cursorline!<CR>
hi CursorLine term=standout cterm=NONE ctermfg=NONE ctermbg=233 gui=NONE guifg=NONE guibg=#eeeeee

" 2015-07-20 and make cursorline vanish for other windows
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END

" 2015-07-20 partially highlight overly long lines
:set cc=+1,+2
:hi ColorColumn ctermbg=233 guibg=#eeeeee

" 2015-06-22 ^.^ ♥ finally, found that one thing that makes vim even better
" set virtualedit=onemore " means I no longer get stuck on that off-by-one char at EOL.
set virtualedit=all " but this means _instant party_

" 2015-06-22 togglable whitespace warnings
" basically this http://stackoverflow.com/questions/11269066/toggling-a-match-in-vimrc?lq=1
hi HighlightRedundantSpaces term=standout ctermbg=234 guibg=yellow
hi link RedundantSpaces HighlightRedundantSpaces
match RedundantSpaces '\(\s\+$\| \+\ze\t\|\t\zs \+\)\(\%#\)\@!'
let s:togglewarnspaces = 1

fun! ToggleRedundantSpaces()
  if s:togglewarnspaces
    hi link RedundantSpaces NONE
    let s:togglewarnspaces = 0
  else
    hi link RedundantSpaces HighlightRedundantSpaces
    let s:togglewarnspaces = 1
  endif
endfun
noremap <F10> :call ToggleRedundantSpaces()<CR>

" 2014-03-20 add colour terminal tweaks
set t_Co=256

" 2014-03-20 lighten comment text because in tilda I can’t read them
:hi Comment ctermfg=Blue

" 2015-05-14 colouring the gitgutter
:hi FoldColumn guibg=darkgrey ctermbg=grey
:hi SignColumn guibg=darkgrey ctermbg=grey guifg=white ctermfg=white
:hi GitGutterAdd guibg=darkgrey ctermbg=darkgrey guifg=green ctermbg=green
:hi GitGutterChange guibg=darkgrey ctermbg=darkgrey guifg=purple ctermbg=yellow " purple was great, for small char
:hi GitGutterDelete guibg=darkgrey ctermbg=darkgrey guifg=red ctermbg=red
:hi GitGutterChangeDelete guibg=darkgrey ctermbg=darkgrey guifg=red ctermbg=red

" 2015-05-14 making the gitgutter diff more visible
" 2043 257C
let g:gitgutter_sign_added				= '++'
let g:gitgutter_sign_removed			= '▒▒' " 2592
let g:gitgutter_sign_removed_first_line	= '▒▒' " 2592
let g:gitgutter_sign_modified			= '▒▒' " 2592
let g:gitgutter_sign_modified_removed	= '▒▒' " 2592

" 2014-03-20 http://jchain.github.io/blog/2013/07/17/fly-with-vim-airline/
set laststatus=2
set guifont=Inconsolata-dz\ for\ Powerline\ 8
" 2014-06-02 disable hunk summary
let g:airline#extensions#hunks#enabled = 0

" 2014-06-02 created this new theme just to fix the greys
" ~/code/vim-airline/autoload/airline/themes/johndrinkwater.vim
let g:airline_theme             = 'johndrinkwater'

" 2014-06-02 whitespace pad to stop REPLACE moving the filename one char over…
let g:airline_mode_map = {
        \ '__' : '------ ',
        \ 'n'  : 'NORMAL ',
        \ 'i'  : 'INSERT ',
        \ 'R'  : 'REPLACE',
        \ 'v'  : 'VISUAL ',
        \ 'V'  : 'V-LINE ',
        \ 'c'  : 'COMMAND',
        \ '' : 'V-BLOCK',
        \ 's'  : 'SELECT ',
        \ 'S'  : 'S-LINE ',
        \ '' : 'S-BLOCK',
        \ }

" 2014-06-02 enabled gitgutter
let g:gitgutter_sign_column_always = 1
let g:gitgutter_override_sign_column_highlight = 0

let g:airline#extensions#branch#enabled    = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline_left_sep          = '⮀'
let g:airline_left_alt_sep      = '⮁'
let g:airline_right_sep         = '⮂'
let g:airline_right_alt_sep     = '⮃'
let g:airline_symbols = {}
let g:airline_symbols.branch    = '⭠'
let g:airline_symbols.readonly  = '⭤'
let g:airline_symbols.linenr    = '⭡'

"   airline_symbols       {'linenr': '⭡', 'paste': 'PASTE', 'readonly': '⭤', 'modified': '+', 'space': ' ', 'whitespace': '!', 'branch': '⭠'
" 2014-03-24 time to get rid of .sw* tmp files
set directory=~/settings/cache/vim,.,/tmp
set backupdir=~/settings/cache/vim,.,/tmp
set nobackup       " no backup files
set noswapfile     " use swap files

" VIM + VIMINIT set in our bash, do we need to touch runtimepath, MYVIMRC?
let g:netrw_home='~/settings/cache/vim/'
set viminfo='100,<50,s10,h,n~/settings/cache/vim/viminfo
set runtimepath=~/settings/config/vim,/etc/vim,/usr/share/vim/vimfiles,/usr/share/vim/addons,/usr/share/vim/vimcurrent,/usr/share/vim/vimfiles,/usr/share/vim/addons/after,~/settings/config/vim/after


set hlsearch
set incsearch
set spelllang=en_gb

" 2014-06-02 added foldlevel to the block below
" 2014-03-20 added a test so this only applies in GUI (gvim) mode, prevents
" obnoxious hightlighting in vim/git commit. Also reduce gutter.
if has("gui_running")
	set spell
	set foldcolumn=6
	set foldlevel=6
else
	set foldcolumn=2
	set foldlevel=3
endif

" 2015-08-24 disabled, as it kept setting tabstop for python to absurd values
" we need to play with this more, as the does help for COMMIT_MSG, and other things
filetype plugin on
filetype indent off

syn region cBlock start=,{, end=,}, transparent fold
syn region cComm start=,/\*, end=,\*/, transparent fold keepend
syn sync fromstart
set foldmethod=syntax

au FileType python set foldmethod=indent

" Transparent editing of gpg encrypted files.
" By Wouter Hanegraaff
augroup encrypted
au!

" First make sure nothing is written to ~/.viminfo while editing
" an encrypted file.
autocmd BufReadPre,FileReadPre *.gpg set viminfo=
" We don’t want a swap file, as it writes unencrypted data to disk
autocmd BufReadPre,FileReadPre *.gpg set noswapfile
" Switch to binary mode to read the encrypted file
autocmd BufReadPre,FileReadPre *.gpg set bin
autocmd BufReadPre,FileReadPre *.gpg let ch_save = &ch|set ch=2
autocmd BufReadPost,FileReadPost *.gpg %!gpg --decrypt 2>/dev/null
" Switch to normal mode for editing
autocmd BufReadPost,FileReadPost *.gpg set nobin
autocmd BufReadPost,FileReadPost *.gpg let &ch = ch_save|unlet ch_save
autocmd BufReadPost,FileReadPost *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

" Convert all text to encrypted text before writing
autocmd BufWritePre,FileWritePre *.gpg %!gpg --default-recipient-self -ae 2>/dev/null
" Undo the encryption so we are back in the normal text, directly
" after the file has been written.
autocmd BufWritePost,FileWritePost *.gpg u
augroup END
