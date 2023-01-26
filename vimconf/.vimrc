" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au BufEnter * if mode() !~# '^c' | checktime | endif

" With a map leader it's possible to do extra key combinations
let mapleader = ","

" Fast saving
nmap <leader>w :w<cr>

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" Always show current position
set ruler
set number

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Smart-ignore case when searching
set ignorecase
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Enable syntax highlighting
set background=dark
syntax enable

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

set virtualedit=block

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

nmap gb :bnext<cr>
nmap gB :bprevious<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=1
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" When to show the status line
set laststatus=0

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" Spell checking
nmap <leader>sp :setlocal spell!<cr>

" Quickly open a buffer for scribble
nmap <leader>o :tabe<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" regex engine autoselect
set re=0

" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set signcolumn=number

" <C-y> to trigger or confirm completion
inoremap <silent><expr> <C-y> coc#pum#visible() ? coc#pum#confirm() : coc#refresh()
" <C-e> to cancel completion or to jump out of quotes, parens, etc.
inoremap <silent><expr> <C-e> "\e/\\%.l[\"'`)\\]}>]\r:noh\ra"

" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> <leader>p <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>n <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  :Format<cr>
nmap <leader>i  :OR<cr>

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,javascript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent> <leader>ld  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <leader>le  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <leader>lc  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <leader>lo  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <leader>ls  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <leader>lj  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>lk  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <leader>lp  :<C-u>CocListResume<CR>

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Close the floating windows
nnoremap <leader>cc :call coc#float#close_all()<CR>

" autoclose pairs
noremap! "" ""<left>
noremap! '' ''<left>
noremap! `` ``<left>
noremap! (( ()<left>
noremap! [[ []<left>
noremap! {{ {}<left>
noremap! <> <><left>
inoremap {<CR> {<CR>}<ESC>O
inoremap [<CR> [<CR>]<ESC>O

let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1

nnoremap <C-t> :NERDTreeToggle<cr>

let g:gitgutter_preview_win_floating = 1

" Create commenter mappings
let g:NERDCreateDefaultMappings = 0
nmap <leader>c<Space> <Plug>NERDCommenterToggle
xmap <leader>c<Space> <Plug>NERDCommenterToggle

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1

let g:coc_global_extensions = [ 'coc-css', 'coc-deno', 'coc-docker',
            \ 'coc-emmet', 'coc-eslint', 'coc-html', 'coc-json', 'coc-prettier',
            \ 'coc-prisma', 'coc-rust-analyzer', 'coc-sh', 'coc-snippets', 'coc-sql',
            \ 'coc-tsserver', 'coc-yaml' ]

let g:coc_user_config = {}
let g:coc_user_config['colors.enable'] = 1

if (has("termguicolors"))
  set termguicolors
endif

" vim plugins (goes to ~/.vim/pack/vendor/start)
" https://github.com/neoclide/coc.nvim.git
" https://github.com/preservim/nerdcommenter.git
" https://github.com/preservim/nerdtree.git
" https://github.com/joshdick/onedark.vim.git
" https://github.com/tpope/vim-fugitive.git
" https://github.com/airblade/vim-gitgutter.git
" https://github.com/sheerun/vim-polyglot
" https://github.com/pantharshit00/vim-prisma.git
" https://github.com/honza/vim-snippets.git
" https://github.com/tpope/vim-surround.git

" Load all plugins
packloadall
" Load all of the helptags
silent! helptags ALL

let g:onedark_color_overrides = {
      \ "foreground":  { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
      \ "background":  { "gui": "NONE", "cterm": "NONE", "cterm16": "NONE" },
      \ }

colorscheme onedark

