" GUI General Options

colorscheme torte   " elflord desert
set number          " Show line numbers
set relativenumber  " Show relative line numbers
set list            " Not sure what this does
set listchars=eol:§,tab:<->,trail:~,extends:>,precedes:<  ",space: 
set guifont=Consolas:h10
set mouse=a         " Mouse on all previous modes
set encoding=utf-8
set fileencoding=utf8
set wrap
set linebreak
syntax on

" Remove beeps
set noerrorbells    " Beep or flash screen on errors
set visualbell      " Use visual bell (no beeping)

" Search options
set smartcase       " Enable smart-case search (lower for all, Upper for Upper)
set hlsearch        " Highlight all search results
set ignorecase      " Always case-insensitive
set incsearch       " Searches for strings incrementally

" Tab-related options
set tabstop=4
set autoindent      " Auto-indent new lines
set expandtab       " Use spaces instead of tabs
set shiftwidth=4    " Number of auto-indent spaces
set smartindent	    " Enable smart-indent
set smarttab        " Enable smart-tabs
"set softtabstop=4  " Number of spaces per Tab

" Advanced
set ruler           " Show row and column ruler information
set undolevels=1000	" Number of undo levels
set backspace=indent,eol,start	" Backspace behaviour

" Backup-related options
if !isdirectory($HOME."/.cache")
  call mkdir($HOME."/.cache", "p", 0700)
endif
set backupdir=~/.cache
set directory=~/.cache

" Remaps
nnoremap <NL> i<CR><ESC> " Ctrl-J to break a line
"'''''''''''''''''''''''''' Functions ''''''''''''''''''''''''

" Function to dinamycally change the status line color
function! ChangeStatuslineColor()
  if (mode() =~# '\v(n|no)')
    "exe 'hi! StatusLine guibg=Salmon'
    hi StatusLine guibg=Salmon
  elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't')
    hi StatusLine guibg=Green
  elseif (mode() ==# 'i')
    hi StatusLine guibg=Purple
  else
    hi StatusLine guibg=Orange
  endif
  return ''
endfunction

" Find out current buffer's size and output it.
function! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif
  if bytes <= 0
    return '0'
  endif
  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endfunction


" Function to transform vim in a word processor
let g:currentmode={
    \ 'n'      : 'N ',
    \ 'no'     : 'N·Operator Pending ',
    \ 'v'      : 'V ',
    \ 'V'      : 'V·Line ',
    \ '\<C-V>' : 'V·Block ',
    \ ''     : 'V·Block ',
    \ 's'      : 'Select ',
    \ 'S'      : 'S·Line ',
    \ '\<C-S>' : 'S·Block ',
    \ 'i'      : 'I ',
    \ 'R'      : 'R ',
    \ 'Rv'     : 'V·Replace ',
    \ 'c'      : 'Command ',
    \ 'cv'     : 'Vim Ex ',
    \ 'ce'     : 'Ex ',
    \ 'r'      : 'Prompt ',
    \ 'rm'     : 'More ',
    \ 'r?'     : 'Confirm ',
    \ '!'      : 'Shell ',
    \ 't'      : 'Terminal '
    \}

" Credits to https://www.maketecheasier.com/turn-vim-word-processor/
func! WordProcessor()
  " movement changes
  map j gj
  map k gk
  colorscheme desert
  " formatting text
  setlocal formatoptions=2n "see help fo-table
  " ^^ format paragraphs and lists as text text
  " setlocal wrap
  " setlocal linebreak
  " setlocal listchars=tab:<->,trail:~,extends:>,precedes:<
  " spelling and thesaurus
  " setlocal spell spelllang=it,en_us,pt
  " set thesaurus+=/home/test/.vim/thesaurus/mthesaur.txt
  " set complete+=s " makes autocompletion search the thesaurus
  set complete+=s
  set nonu nornu  "Hides row display
endfu

func NoWordProcessor()
  " Undo changes
  map j j
  map k k
  colorscheme torte   " elflord desert
  " formatting text
  setlocal formatoptions=ljo " see help fo-table
  " ^^ don't break lines join comments continue comments
  " doesn't seem to work well
  " setlocal wrap
  " setlocal linebreak
  " setlocal listchars=tab:<->,trail:~,extends:>,precedes:<
  " spelling and thesaurus
  setlocal nospell
  " complete+=s makes autocompletion search the thesaurus
  " set complete+=s
  set nu rnu  "Hides row display
  " restores original behavior
endfu

" Call functions
" set statusline+=\ %f                                    " show filename
set laststatus=2                                        " 2 -> Always display statline
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}  " Current mode
set statusline+=%F                                      " show fullpath filename
set statusline+=\ %y                                    " Show file type
set statusline+=[%{strlen(&fenc)?&fenc:'none'},         " file encoding
"set statusline+=%8*%-3(%{FileSize()}%)]                " File size
set statusline+=%{FileSize()}]                          " File size
set statusline+=%c                                      " show col number
set statusline+=-%l/%L                                  " show row number
set statusline+=(%p%%)                                  " Show Completion percentage
set statusline+=[B%n]                                   " Show Buffer number
set statusline+=%{ChangeStatuslineColor()}              " Changing the statusline color

com! WP call WordProcessor()
com! NWP call NoWordProcessor()
call NoWordProcessor()
