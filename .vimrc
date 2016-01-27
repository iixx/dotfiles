set nocompatible

function! s:main()
    call s:before()
    call s:common()
    call s:editor()
    call s:plugins()
    call s:UI()
    call s:keyMappings()
    call s:guiOrTerm()
endfunction


function! s:before()
    call s:platformInit()
    let s:backupDir = expand($vimrcDir.'/.vim-backup')
    let s:undoDir = expand($vimrcDir.'/.vim-undo')
    if has('gui_running')
        set guioptions+=M
    endif
endfunction


function! s:common()
    set shortmess+=filmnrxoOtTI
    set history=2048
    set helplang=cn
    set mouse=a mousehide
    set title titleold=
    set hidden
    set timeout timeoutlen=1200 ttimeout ttimeoutlen=100
    set viewoptions=folds,options,cursor,unix,slash
    set display+=lastline
    set tabpagemax=20
    set wildmenu wildmode=list:longest,full

    set fileformat=unix
    set fileformats=unix,dos
    set encoding=utf-8
    setglobal fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

    if has('clipboard')
        if has('unnamedplus')
            set clipboard=unnamed,unnamedplus
        else
            set clipboard=unnamed
        endif
    endif

    if isdirectory(s:backupDir)
        set backup
        exec 'set bdir='.s:backupDir
    endif
    if has('persistent_undo') && isdirectory(s:undoDir)
        set undofile undolevels=1000 undoreload=10000
        exec 'set undodir='.s:undoDir
    endif
endfunction


function! s:guiOrTerm()
    if has('gui_running')
        if s:isWindows()
            winpos 192 50
            set lines=40 columns=128
            set guioptions-=T guioptions-=m guioptions-=e
            set guifont=Microsoft_YaHei_Mono:h11
            set guicursor=n-v-c:hor10-Cursor/lCursor,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver10-Cursor/lCursor,r-cr:hor20-Cursor/lCursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
            set background=light
            set winaltkeys=no
            "autocmd GUIEnter * simalt ~x
        endif
    else
        set term=$TERM
        if &term[:4] == 'xterm' || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            set t_Co=256
            inoremap <silent> <C-[>OC <RIGHT> " arrow key fix
        endif
    endif
endfunction


function! s:platformInit()
    " Identify platform {
        function! s:isWindows()
            return  (has('win32') || has('win64'))
        endfunction
        function! s:isCygwin()
            return has('win32unix')
        endfunction
        function! s:isLinux()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        function! s:isMac()
            return has('macunix')
        endfunction
    " }

    let $vimrcDir = $HOME
    if s:isWindows()
        set rtp+=$HOME/.vim,$HOME/.vim/after
        language messages zh_CN.utf-8
        if exists('g:vimrcDir_on_windows')
            let $vimrcDir = g:vimrcDir_on_windows
        endif
    else
        set shell=/bin/bash
        if s:isCygwin()
            let $vimrcDir = substitute(system("cygpath -m $HOME"), "\n", "", "")
        endif
    endif
endfunction


function! s:editor()
    set cursorline
    set number relativenumber
    set smarttab expandtab tabstop=4 shiftwidth=4
    set autoindent smartindent
    set ignorecase smartcase
    set nrformats-=octal
    set virtualedit=onemore
    set backspace=indent,eol,start
    set whichwrap=b,s,h,l,<,>,[,]
    set wrap textwidth=0
    set nojoinspaces formatoptions+=mM
    set hlsearch incsearch
    set foldenable foldmethod=syntax foldlevel=10 foldcolumn=1
    set autoread
    set scrolljump=-50 scrolloff=1 sidescrolloff=10
    set list listchars=tab:›\ ,trail:·,extends:>,nbsp:.
endfunction


function! s:UI()
    function! ToggleBG()
        if &background == "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction

    syntax enable | syntax on
    set background=dark

    if filereadable(expand("$vimrcDir/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=256
        let g:solarized_termtrans=1
        let g:solarized_contrast="normal"
        let g:solarized_visibility="normal"
        colorscheme solarized
    endif

    set ruler
    set showcmd
    set showmatch
    set linespace=0
    set winminheight=0
    set splitright splitbelow
    set laststatus=2
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
endfunction


function! s:keyMappings()
    let mapleader = '\'
    map <space> <leader>

    " Common key {
        noremap j gj
        noremap k gk
        noremap J gJ
        noremap gJ J
        noremap zl zL
        noremap zh zH
        noremap <C-J> <C-W>j<C-W>_
        noremap <C-K> <C-W>k<C-W>_
        noremap <C-L> <C-W>l<C-W>_
        noremap <C-H> <C-W>h<C-W>_

        nnoremap Y y$

        inoremap <C-K> <Up>
        inoremap <C-J> <Down>
        inoremap <C-H> <Left>
        inoremap <C-L> <Right>
        inoremap <C-U> <C-G>u<C-U>
        inoremap <C-R> <C-R><C-O>
        inoremap <C-V> <C-R><C-O>*

        vnoremap < <gv
        vnoremap > >gv
        vnoremap . :normal .<CR>
    " }

" Leader key {
        nnoremap <leader>a ggvG$
        nnoremap <leader>bg :call ToggleBG()<CR>

        nmap <leader>/ :set invhlsearch<CR>
        nmap <leader>f0 :set foldlevel=0<CR>
        nmap <leader>f1 :set foldlevel=1<CR>
        nmap <leader>f2 :set foldlevel=2<CR>
        nmap <leader>f3 :set foldlevel=3<CR>
        nmap <leader>f4 :set foldlevel=4<CR>
        nmap <leader>f5 :set foldlevel=5<CR>
        nmap <leader>f6 :set foldlevel=6<CR>
        nmap <leader>f7 :set foldlevel=7<CR>
        nmap <leader>f8 :set foldlevel=8<CR>
        nmap <leader>f9 :set foldlevel=9<CR>
    " }

    " Function key {
        " Same for 0, home, end, etc
        function! WrapRelativeMotion(key, ...)
            let vis_sel=""
            if a:0
                let vis_sel="gv"
            endif
            if &wrap
                execute "normal!" vis_sel . "g" . a:key
            else
                execute "normal!" vis_sel . a:key
            endif
        endfunction

        " Map g* keys in Normal, Operator-pending, and Visual+select
        noremap $ :call WrapRelativeMotion("$")<CR>
        noremap <End> :call WrapRelativeMotion("$")<CR>
        noremap 0 :call WrapRelativeMotion("0")<CR>
        noremap <Home> :call WrapRelativeMotion("0")<CR>
        noremap ^ :call WrapRelativeMotion("^")<CR>
        " Overwrite the operator pending $/<End> mappings from above
        " to force inclusive motion with :execute normal!
        onoremap $ v:call WrapRelativeMotion("$")<CR>
        onoremap <End> v:call WrapRelativeMotion("$")<CR>
        " Overwrite the Visual+select mode mappings from above
        " to ensure the correct vis_sel flag is passed to function
        vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
    " }

    " Event {
        " Always switch to the current file directory
        "autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
        autocmd bufreadpost * silent! exec "normal! g'\""
    " }
endfunction


function! s:pluginSettings()
    function! s:existPlugin(pluginName)
        return isdirectory(expand("$vimrcDir/.vim/bundle/".a:pluginName))
    endfunction

    " easymotion {
        if s:existPlugin("vim-easymotion")
            let g:EasyMotion_smartcase = 1
            nmap t <Plug>(easymotion-s2)
        endif
    " }

    " airline {
        if s:existPlugin("vim-airline")
            let g:airline_left_sep = '›'
            let g:airline_right_sep = '‹'
            let g:airline#extensions#branch#enabled = 1
            let g:airline#extensions#whitespace#enabled = 1
            let g:airline#extensions#hunks#non_zero_only = 1
            let g:airline#extensions#bufferline#enabled = 1
            let g:airline#extensions#bufferline#overwrite_variables = 1
        endif
    " }

    " bufferline {
        if s:existPlugin("vim-bufferline")
            let g:bufferline_echo = 0
        endif
    " }

    " NerdTree {
        if s:existPlugin("nerdtree")
            map <silent> <F1> :NERDTreeToggle<CR>
            map <silent!> <leader>e :NERDTreeFind<CR>
            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.class$', '\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
        endif
    " }

    " Rainbow {
        if s:existPlugin("rainbow")
            let g:rainbow_active = 1
            let g:rainbow_conf = {
                \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
                \   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
                \   'operators': '_,_',
                \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
                \   'separately': {
                \       '*': {},
                \       'tex': {
                \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
                \       },
                \       'lisp': {
                \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
                \       },
                \       'vim': {
                \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
                \       },
                \       'html': {
                \           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
                \       },
                \       'css': 0,
                \   }
                \}
        endif
    "}

    " matchit {
        if s:existPlugin("matchit.zip")
            let b:match_ignorecase = 1
        endif
    " }

    " UndoTree {
        if s:existPlugin("undotree")
            let g:undotree_SetFocusWhenToggle=1
            nnoremap <silent> <Leader>u :UndotreeToggle<CR>
        endif
    " }

    " PyMode {
        if s:existPlugin("python-mode")
            if !has('python') && !has('python3')
                let g:pymode = 0
            else
                let g:pymode_lint_checkers = ['pyflakes']
                let g:pymode_trim_whitespaces = 0
                let g:pymode_options = 0
                let g:pymode_rope = 0
            endif
        endif
    " }

    " ctrlp {
        if s:existPlugin("ctrlp.vim")
            let g:ctrlp_working_path_mode = 'ra'
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$|\.class$' }

            if executable('ag')
                let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
            elseif executable('ack-grep')
                let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
            elseif executable('ack')
                let s:ctrlp_fallback = 'ack %s --nocolor -f'
            " On Windows use "dir" as fallback command.
            elseif s:isWindows()
                let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
            else
                let s:ctrlp_fallback = 'find %s -type f'
            endif
            if exists("g:ctrlp_user_command")
                unlet g:ctrlp_user_command
            endif
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
                \ }

            if s:existPlugin("ctrlp-funky")
                let g:ctrlp_extensions = ['funky']
                let g:ctrlp_funky_syntax_highlight = 1
                nnoremap <Leader>fu :CtrlPFunky<Cr>
            endif
        endif
    "}

    " tagbar {
        if s:existPlugin("tagbar")
            nnoremap <silent> <leader>tt :TagbarToggle<CR>
        endif
    "}

    " indentline {
        if s:existPlugin("indentline")
            let g:indentLine_enabled = 0
            nnoremap <silent> <leader>il :IndentLinesToggle<CR>
        endif
    " }

    " Wildfire {
        if s:existPlugin("wildfire.vim")
            let g:wildfire_objects = {
                        \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
                        \ "html,xml" : ["at"],
                        \ }
        endif
    " }

    " session man {
        if s:existPlugin("sessionman.vim")
            set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
            nmap <leader>sl :SessionList<CR>
            nmap <leader>ss :SessionSave<CR>
            nmap <leader>sc :SessionClose<CR>
        endif
    " }

    " syntastic {
        if s:existPlugin("syntastic")
            "let g:syntastic_check_on_open = 1
            let g:syntastic_check_on_wq = 0
            let g:syntastic_auto_loc_list = 1
            let g:syntastic_always_populate_loc_list = 1
            let g:loaded_syntastic_java_javac_checker = 1
        endif
    " }
endfunction


function! s:plugins()
    if !isdirectory($vimrcDir.'/.vim/bundle/Vundle.vim')
        echo 'Vundle is not available'
        filetype plugin indent on
        return
    endif
    filetype off
    set rtp+=$vimrcDir/.vim/bundle/Vundle.vim
    let s:git_version = system('git --version')
    if(s:git_version =~ 'msysgit' || s:git_version =~ 'windows')
        call vundle#begin($vimrcDir.'/.vim/bundle')
    else
        call vundle#begin()
    endif
    Plugin 'VundleVim/Vundle.vim'
    " common {
        Plugin 'scrooloose/nerdtree'
        Plugin 'ctrlpvim/ctrlp.vim'
        Plugin 'tacahiroy/ctrlp-funky'
        Plugin 'easymotion/vim-easymotion'
        Plugin 'terryma/vim-multiple-cursors'
        Plugin 'gcmt/wildfire.vim'
        Plugin 'vim-scripts/sessionman.vim'
    " }

    " UI {
        Plugin 'altercation/vim-colors-solarized'
        Plugin 'bling/vim-airline'
        Plugin 'bling/vim-bufferline'
        Plugin 'luochen1990/rainbow'
        Plugin 'Yggdroot/indentLine'
        "Plugin 'yonchu/accelerated-smooth-scroll'
    " }

    " feature {
        Plugin 'mbbill/undotree'
        Plugin 'tpope/vim-fugitive'
        Plugin 'gregsexton/gitv'
    " }

    " code {
        Plugin 'taglist.vim'
        Plugin 'TaskList.vim'
        Plugin 'majutsushi/tagbar'
        Plugin 'matchit.zip'
        Plugin 'gregsexton/MatchTag'
        Plugin 'Townk/vim-autoclose'
        Plugin 'tpope/vim-surround'
        Plugin 'tpope/vim-commentary'
        Plugin 'mattn/emmet-vim'
        "Plugin 'scrooloose/syntastic'
        "Plugin 'klen/python-mode'
        "Plugin 'artur-shaik/vim-javacomplete2'
    " }
    call vundle#end()
    filetype plugin indent on
    call s:pluginSettings()
endfunction

call s:main()
