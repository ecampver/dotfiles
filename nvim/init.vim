call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdtree'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdcommenter'
Plug 'simeji/winresizer'
Plug 'heavenshell/vim-jsdoc', { 
      \ 'for': ['javascript', 'javascript.jsx', 'typescript'], 
      \ 'do': 'make install'
      \}
Plug 'peitalin/vim-jsx-typescript'
Plug 'leafgarland/typescript-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'szw/vim-maximizer'

call plug#end()

" Gruvbox config
let g:gruvbox_contrast_dark = 'dark'

" Lightline config
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

autocmd TermOpen * set bufhidden=hide

set termguicolors
set background=dark

set encoding=UTF-8
set relativenumber
set ignorecase
set smartcase

filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab

colorscheme gruvbox

" Own mappings
let mapleader = ','

imap jk <ESC>
nnoremap <Leader><Space> :nohlsearch<CR>

nnoremap [<Space> O<ESC>
nnoremap ]<Space> o<ESC>
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>

nmap <c-h> <c-w>h
nmap <c-l> <c-w>l
nmap <c-j> <c-w>j
nmap <c-k> <c-w>k
nmap J gT
nmap K gt

" Yanking/Pasting
nmap <A-y> "+y
vmap <A-y> "+y
nmap <A-p> "+p`]
nmap <A-P> "+P`]
vmap <A-p> "+p`]
imap <A-p> <ESC><A-p>`]a
imap <A-P> <ESC><A-P>`]a

" Vim-Maximizer
nnoremap <silent> <leader><c-m> :MaximizerToggle<CR>

" JSX/TSX
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact

" JsDoc mappings
nmap <Leader>d :JsDoc<CR>

" NERDTree mappings and configs
let g:NERDTreeWinSize = 50
nmap <Leader>m :NERDTreeToggle<CR>
nmap <Leader>l :NERDTreeFind<CR>

" Fugitive mappings
nmap <Leader>gs :G<CR>
nmap <Leader>gj :diffget //3<CR>
nmap <Leader>gf :diffget //2<CR>

" CoC mappings
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" coc-prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Denite mappings/config
nnoremap <A-b> :Denite buffer<CR>
nmap <C-p> :DeniteProjectDir file/rec<CR>
nnoremap <C-f> :<C-u>Denite grep:. -no-empty<CR>

call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

call denite#custom#var('buffer', 'date_format', '')

call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

let s:denite_options = {'default' : {
      \ 'split': 'floating',
      \ 'start_filter': 1,
      \ 'auto_resize': 1,
      \ 'source_names': 'short',
      \ 'prompt': 'λ ',
      "\ 'highlight_matched_char': 'QuickFixLine',
      "\ 'highlight_matched_range': 'Visual',
      "\ 'highlight_window_background': 'Visual',
      "\ 'highlight_filter_background': 'DiffAdd',
      \ 'winrow': 1,
      \ 'vertical_preview': 1,
      \ 'preview_width': 100
      \ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
        \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> t
        \ denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> q
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
        \ denite#do_map('toggle_select').'j'
endfunction

