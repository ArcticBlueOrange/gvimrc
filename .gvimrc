" GUI General Options

colorscheme torte " elflord desert
set number          " Show line numbers
set relativenumber  " Show relative line numbers
set list            " Not sure what this does
set listchars=eol:§,tab:<->,trail:~,extends:>,precedes:<  ",space: 
set guifont=Consolas:h10
set mouse=a         " Mouse on all previous modes
set fileencoding=utf8

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
set nobackup        " Easy option - no backup clutter
set nowritebackup   " 
set noswapfile
"https://vim.fandom.com/wiki/Remove_swap_and_backup_files_from_your_working_directory " It still creates the ~ file, but every time you fire up VIM it nukes all the old junk. And if for some wierd reason you actually need the ~ file you can go back into the temp folder and rescue it before starting VIM
" Creates issues atm
"set backupdir=$VIMRUNTIME\\temp\\
"set directory=$VIMRUNTIME\\temp\\
"silent execute '!del "'.$VIMRUNTIME.'\temp\*~"'


"'''''''''''''''''''''''''' Functions ''''''''''''''''''''''''

" Function to dinamycally change the status line color
function! ChangeStatuslineColor()
  if (mode() =~# '\v(n|no)')
    exe 'hi! StatusLine guibg=Teal'
  elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't')
    exe 'hi! StatusLine guibg=Green'
  elseif (mode() ==# 'i')
    exe 'hi! StatusLine guibg=Purple'
  else
    exe 'hi! StatusLine guibg=SlateBlue'
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

func! WordProcessor()
  " movement changes
  map j gj
  map k gk
  " formatting text
  setlocal formatoptions=1
  setlocal noexpandtab
  setlocal wrap
  setlocal linebreak
  " spelling and thesaurus
  setlocal spell spelllang=it,en_UK,pt_PT
  set thesaurus+=/home/test/.vim/thesaurus/mthesaur.txt
  " complete+=s makes autocompletion search the thesaurus
  set complete+=s
  set nonu nornu  "Hides row display
endfu


" Call functions
set laststatus=2                                         " 2 -> Always display statline
set statusline+=\ %f                                     " show filename
set statusline+=%{ChangeStatuslineColor()}               " Changing the statusline color
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}   " Current mode
set statusline+=%8*\ %-3(%{FileSize()}%)                 " File size
" 

com! WP call WordProcessor()
"com! WP call WordProcessor(1) 
"com! noWP call WordProcessor(0) " Undo wordprocessor mode
