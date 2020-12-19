let mapleader = " "

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'jremmen/vim-ripgrep'
Plug 'ryanoasis/vim-devicons'
Plug 'jreybert/vimagit'
Plug 'bling/vim-airline'
Plug 'kovetskiy/sxhkd-vim'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript'
Plug 'w0rp/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'git@github.com:mbbill/undotree.git'
Plug 'ap/vim-css-color'
Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()

set bg=dark
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set list lcs=tab:\┊\ 

colorscheme dracula 
let g:airline_theme='dracula'

" Some basics:
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber
	set noerrorbells
	set tabstop=4 softtabstop=4
	set shiftwidth=4
	set smartindent
	set incsearch

" Auto indent
	nnoremap <leader>w ggVG=<CR>
" Open Undotree
	map <leader>z :UndotreeShow<CR>
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Spell-check set to <leader>o, 'o' for 'orthography':
	nnoremap <leader>o :setlocal spell! spelllang=en_us<CR>
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow
" Nerd tree
	nnoremap <leader>n :NERDTreeToggle<CR>

	nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
	nnoremap <leader>ps :Rg<SPACE>

"Plugin Options
	if executable('rg')
		let g:rg_derive_root='true'
	endif

	let g:netrw_browse_split=2
	let g:netrw_winsize=25
	let g:ctrlp_use_caching=0
	let g:airline_powerline_fonts = 1

" ESLint
	let g:ale_fixers = {
	\ 'javascript': ['eslint']
	\ }

	highlight ALEError ctermbg=none cterm=undercurl
	highlight ALEWarning ctermbg=none cterm=undercurl
	let g:ale_sign_error = '❌'
	let g:ale_sign_warning = '⚠️'
	let g:ale_fix_on_save = 1

" coc.nvim
	nmap <silent> <leader>dd <Plug>(coc-definition)
	nmap <silent> <leader>dr <Plug>(coc-references)
	nmap <silent> <leader>dj <Plug>(coc-implementation)
	nmap <silent> <leader>ac <Plug>(coc-codeaction)
	nmap <silent> <leader>qf <Plug>(coc-fix-current)

"NerdTree
	autocmd StdinReadPre * let s:std_in=1
	autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Shortcutting split navigation, saving a keypress:
	nnoremap <leader>h :wincmd h<CR>
	nnoremap <leader>j :wincmd j<CR>
	nnoremap <leader>k :wincmd k<CR>
	nnoremap <leader>l :wincmd l<CR>

" Replace ex mode with gq
	map Q gq

" Check file in shellcheck:
	nnoremap <leader>s :!clear && shellcheck %<CR>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
	nnoremap <leader>c :w! \| !compiler <c-r>%<CR>

" Open corresponding .pdf/.html or preview
	nnoremap <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	nnoremap <leader>v :VimwikiIndex
	let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	command W :execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Automatically deletes all trailing whitespace and newlines at end of file on save.
if expand('%:t') == 'init.vim'
else
	autocmd BufWritePre * %s/\s\+$//e
endif
	autocmd BufWritepre * %s/\n\+\%$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost files,directories !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
" Update binds when sxhkdrc is updated.
	autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
" Make after modifying all suckless software config
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }
	autocmd BufWritePost ~/.local/src/dwm/config.h !cd ~/.local/src/dwm/; sudo make install && { killall -q dwm;setsid dwm & }
	autocmd BufWritePost ~/.local/src/dmenu/config.h !cd ~/.local/src/dmenu/; sudo make install && { killall -q dmenu;setsid dmenu & }
	autocmd BufWritePost ~/.local/src/st/config.h !cd ~/.local/src/st/; sudo make install && { killall -q st ;setsid st & }

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif
