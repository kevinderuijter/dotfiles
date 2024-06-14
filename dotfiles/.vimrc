filetype plugin indent on 	" Switch on the filetype -plugin, -indent and -on mechanisms.
syntax on 					" Enable highlighting files in color.
set number 					" Display line numbers.
set nowrapscan 				" Stop searching when reached end of file.
set incsearch 				" Display the match for a search whilst typing.
set smartcase 				" Use case sensitive when present in the search term.
packadd! matchit 			" Built-in package to match tag jumps with <%> keybind.
set shiftwidth=4			" Number of spaces an indentation stands for.
set tabstop=4				" Number of spaces that a tab stands for.
set smarttab				" Insert blanks according to shiftwidth when <Tab> is pressed.
set nocompatible			" Use Vim defaults instead of 100% vi compatibility.
set showcmd 				" Display incomplete commands.
set wildmenu 				" Display completion matches in status line on <Tab>.
set ttimeout				" This makes typing Esc take effect more quickly.
set ttimeoutlen=100 		" Increase on slow connections.
set wrap 					" Wrap lines longer than display.
