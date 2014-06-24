set guifont=DejaVu\ Sans\ Mono\ 8
set shiftwidth=4

set softtabstop=4
set tabstop=4
"set foldmethod=marker
"set foldmarker={,}

" 2014-02 adding some sugar
set listchars=tab:⇢ ,trail:⌁,eol:⌞,extends:↦,precedes:⌇,nbsp:⌅
"set list
noremap <F11> :set list!<CR>
set cursorline
"not sure about two lines below, yes these are problematic, but might be
"distracting
highlight RedundantSpaces term=standout ctermbg=Grey guibg=yellow
call matchadd('RedundantSpaces', '\(\s\+$\| \+\ze\t\|\t\zs \+\)\(\%#\)\@!')

" 2014-03-20 add colour terminal tweaks
set t_Co=256

" 2014-03-20 lighten comment text because in tilda I can’t read them
:hi Comment ctermfg=Blue

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

let g:airline_enable_branch     = 1
let g:airline_enable_syntastic  = 1
let g:airline_left_sep          = '⮀'
let g:airline_left_alt_sep      = '⮁'
let g:airline_right_sep         = '⮂'
let g:airline_right_alt_sep     = '⮃'
let g:airline_branch_prefix     = '⭠'
let g:airline_readonly_symbol   = '⭤'
let g:airline_linecolumn_prefix = '⭡'

"   airline_symbols       {'linenr': '⭡', 'paste': 'PASTE', 'readonly': '⭤', 'modified': '+', 'space': ' ', 'whitespace': '!', 'branch': '⭠'
" 2014-03-24 time to get rid of .sw* tmp files
set directory=~/.cache/vim,.,~/tmp,/tmp
set backupdir=~/.cache/vim,.,~/tmp,/tmp
" still need to set XDG stuffs in viminfo, runtimepath, MYVIMRC

set hlsearch
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

filetype plugin on

syn region cBlock start=,{, end=,}, transparent fold
syn region cComm start=,/\*, end=,\*/, transparent fold keepend
syn sync fromstart
set foldmethod=syntax

au FileType python set foldmethod=indent

:source ~/.vim/plugin/minimap.vim
" for binary files
" :source ~/.vim/plugins/hexman.vi
" commented out 2010-11-05
" augroup Binary
"  au BufReadPre *.n50,*.n52 exe MGI source ~/.vim/plugins/hexman.vim
"  au BufRead *.n50,*.n52 exe MGI "normal \\hm"
"  au BufWritePre *.n50,*.n52 exe MGI "normal \\hm"
"  au BufWritePost *.n50,*.n52 exe MGI "normal \\hm"

" au BufRead  *.n50 call <Plug>HexManage
"augroup END

" vim -b : edit binary using xxd-format!
"augroup Binary
"  au!
"  au BufReadPre  *.n50 let &bin=1
"  au BufReadPost *.n50 if &bin | %!xxd
"  au BufReadPost *.n50 set ft=xxd | endif
"  au BufWritePre *.n50 if &bin | %!xxd -r
"  au BufWritePre *.n50 endif
"  au BufWritePost *.n50 if &bin | %!xxd
"  au BufWritePost *.n50 set nomod | endif
"augroup END



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
