" wburningham's vimrc file
" https://github.com/wburningham/dotfiles/blob/master/.vimrc
" Many of the item in my vimrc were taken from Derek Wyatt's vim videos (http://derekwyatt.org/vim/tutorials/).Be sure to check out the Just One Vim video (http://bit.ly/igCErk).



" TODO http://learnvimscriptthehardway.stevelosh.com/
" TODO http://stackoverflow.com/questions/102384/using-vims-tabs-like-buffers
" TODO cmd_d select word under cursor

" TODO Strip trailing whitespace on save

" TODO Strip trailing whitespace
"function! StripWhitespace()
"	let save_cursor = getpos(".")
"	let old_query = getreg('/')
"	:%s/\s\+$//e
"	call setpos('.', save_cursor)
"	call setreg('/', old_query)
"endfunction
"noremap <leader>ss :call StripWhitespace()<CR>







" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
" required for Vundle
filetype off "required for Vundle

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'joonty/vdebug'

" NerdTree - http://www.vim.org/scripts/script.php?script_id=1658
Plugin 'scrooloose/nerdtree'

" Lean & mean status/tabline for vim that's light as air.
Plugin 'bling/vim-airline'

" Toggle - http://www.vim.org/scripts/script.php?script_id=895
" Toogle allows you to toggle bool (true/false) and other words with the "+"
Plugin 'Toggle'

" tComment - http://www.vim.org/scripts/script.php?script_id=1173
" An extensible & universal comment plugin that also handles embedded filetypes 
" info -> :help tComment
Plugin 'tomtom/tcomment_vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on

" Enable filetypes
filetype plugin on
filetype indent on



"----- Category? -----
" Allow switching buffers without saving
set hidden

" Enable mouse in all modes?
set mouse+=a

" Disable error bells
set noerrorbells


" Make the command-line completion better
set wildmenu

"Split windows BELOW current window
set splitbelow

" Don’t add empty newlines at the end of files
set binary
set noeol

" Centralize backups, swapfiles and undo history
" Won't clutter up your working directory
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif


" Indent settings
set autoindent
set smartindent

" Tab settings
set tabstop=2
set shiftwidth=3
set softtabstop=3

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Optimize for fast terminal connections
set ttyfast

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed

" Allow backspace in insert mode
set backspace=indent,eol,start




"----- Mappings -----
"Saves time 
nmap <space> :

"Map escape key to jj -- much faster
imap jj <esc>

" Maps change word to change inner word.
nmap cw ciw

"Shortcut for editing vimrc file & source the vimrc afer edit
nmap ,ev :tabnew $MYVIMRC<cr>
if has("autocmd")
	autocmd bufwritepost .vimrc source $MYVIMRC
endif

" If you select some lines then press > to indent the lines, the selection is removed. The indentation can be repeated on the same range using ., but if you still want to retain the visual selection after having pressed > or <, you can use these mappings
vnoremap > >gv
vnoremap < <gv

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Map CTRL-E to do what ',' used to do
nnoremap <c-e> ,
vnoremap <c-e> ,

"Shorcut for NERDTreeToggle
nmap ,nt :NERDTreeToggle<cr>
nmap nt :NERDTreeToggle<cr>





"----- Search Settings -----
" Enable search highlighting
set hlsearch
" set the search scan to wrap lines
set wrapscan
" Incrementally match the search
set incsearch
" set the search scan so that it ignores case when the search is all lower
" case but recognizes uppercase if it's specified
set ignorecase
set smartcase



"----- Look and Feel -----
" Syntax coloring lines that are too long just slows down the world
set synmaxcol=2048

" Switch on syntax highlighting.
syntax on

" Theme favs: dusk, dw_cyan
colorscheme molokai
set linespace=3
set guifont=Monaco:h14

" airline
let g:airline_theme = 'molokai'

" Hide the mouse pointer while typing
set mousehide

" Show the current mode
set showmode

" Show the (partial) command as it’s being typed
set showcmd

" Show the filename in the window titlebar
set title

"Show line numbers
set number

" Don’t show the intro message when starting Vim
set shortmess=atI

" Show the current cursor position in the lower right corner
set ruler

" Display the status line always
set laststatus=2




"----- Plugin Settings -----

" T-comment
"Faster shortcut for commenting. Requires T-Comment plugin
map ,c <c-_><c-_>
" cmd+/ like SublimeText
map <D-/> <c-_><c-_>

" Command-T shorcut
nmap ff <leader>t

" open a NERDTree automatically when vim starts up
"if has("autocmd")
"	autocmd vimenter * NERDTree
"endif
" Show hidden files in NerdTree
let NERDTreeShowHidden=1   
" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1
" Don't display these kinds of files
let NERDTreeIgnore=[ '\.ncb$', '\.suo$', '\.vcproj\.RIMNET', '\.obj$',
            \ '\.ilk$', '^BuildLog.htm$', '\.pdb$', '\.idb$',
            \ '\.embed\.manifest$', '\.embed\.manifest.res$',
            \ '\.intermediate\.manifest$', '^mt.dep$' ]




"----- Fix constant spelling mistakes -----
" TODO add from sublime plugin list
iab teh				the
iab hte				the
iab Hte				The
iab Teh				The
iab taht			that
iab Taht			That
iab alos			also
iab Alos			Also
iab aslo			also
iab Aslo			Also
iab becuase			because
iab Becuase			Because
iab charcter		character
iab Charcter		Character
iab charcters		characters
iab Charcters		Characters
iab exmaple			example
iab Exmaple			Example
iab exmaples		examples
iab Exmaples		Examples
iab shoudl			should
iab Shoudl			Should
iab seperate		separate
iab Seperate		Separate
iab everythign		everything
iab Everythign		Everything
iab anythign		anything
iab Anythign		anything
iab wahts			whats
iab waht			what
iab Wahts			Whats
iab Waht			What
iab pubilc			public
iab Pubilc			Public
iab defualt			default
iab Defualt			Default
iab roght			right
iab Roght			Right
iab performa		performs
iab Performa		Performs
iab searhc			search
iab Searhc			Search
iab roels			roles
iab Roels			Roles
iab removs			removes
iab Removs			Removes
iab reccommend		recommend
iab Reccommend		Recommend
iab cahnged			changed
iab Cahnged			Changed
iab Haev			Have
iab haev			have
iab somethign		something
iab Somethign		Something
iab Otehrwise		Otherwise
iab otehrwise		otherwise
iab tehere			there
iab Tehere			There
iab tpye			type
iab Tpye			Type
iab differnt		different
iab Differnt		Different
iab charaters		characters
iab Charaters		Characters
iab charater		character
iab Charater		Character
iab begining		beginning
iab Begining		Beginning
iab proccessor		processor
iab Proccessor		Processor
iab reponse			response
iab Reponse			Response
iab Surevy			Survey
iab surevy			survey
iab avalibale		avaliable
iab Avalibale		Avaliable
iab everthing		everything
iab startes			starts
iab gam				game
iab REbecca			Rebecca
iab wnt				want
iab agin			again
iab htat			that
iab stroner			stronger
iab adn				and
iab trak			track
iab wansts			wants
iab dooing			dooing
iab anf				and
iab amzaing			amazing
iab thay			they
iab lvo				love
iab biship			bishop
iab Biship			Bishop
iab charis			chairs
iab chari			chair
iab goin			going


"----- Auto Commands -----
if has("autocmd")

	" Source the vimrc file afer modifying
	autocmd bufwritepost .vimrc source $MYVIMRC

endif
