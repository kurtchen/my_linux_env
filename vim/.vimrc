" ================ Plugins =====================
" {
call plug#begin()
  Plug 'altercation/vim-colors-solarized'
  Plug 'preservim/nerdtree'
  Plug 'azabiong/vim-highlighter'
  Plug 'preservim/tagbar'
  Plug 'tpope/vim-fugitive'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
call plug#end()
" } // Plugins

" ================= Settings ====================
" {
" > General Settings
"   {
      set encoding=utf-8

      set t_Co=256
      set background=dark
      set hlsearch
      syntax on

      set autoindent                  " Indent at the same level of the previous line
      set shiftwidth=4                " Use indents of 4 spaces
      set expandtab                   " Tabs are spaces, not tabs
      set tabstop=4                   " An indentation every four columns
      set softtabstop=4               " Let backspace delete indent
"   } // General Settings

" > Plugin Settings
"   {

" >>  solarized Settings
"     {
        let g:solarized_termcolors=256
        let g:solarized_termtrans=1
        let g:solarized_contrast="normal"
        let g:solarized_visibility="normal"
        colorscheme solarized
"     } // solarized settings

" >>  NERDTree Settings
"     {
        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
        " NERD Tree for all tab, and auto mirror
        " nnoremap <C-e> :NERDTreeTabsToggle<CR>:NERDTreeMirror<CR>
"     } NERDTree settings

"   } // Plugin Settings
" } // Settings

" ================= Key Mappings ====================
" {
" > General Key Mappings
"   {
      let mapleader = ','
      inoremap <silent> jk <Esc>l
"   } // General Key Mappings

" > Plugin Key Mappings
"   {

" >>  NERDTree Key Mappings
"     {
        map <C-e> :NERDTreeToggle<CR>
        map <leader>e :NERDTreeFind<CR>
"     } NERDTree Key Mappings

" >>  vim-highlighter Key Mappings
"     {
        let HiSet   = '<leader>mm'
        let HiErase = '<leader>md'
        let HiClear = '<leader>mc'
        let HiFind  = '<leader>mf'
        
        " jump key mappings
        nn <leader>mn    <Cmd>Hi><CR>
        nn <leader>mN    <Cmd>Hi<<CR>
        nn <leader>m*    <Cmd>Hi{<CR>
        nn <leader>m#    <Cmd>Hi}<CR>
        
        " find key mappings
        " nn -        <Cmd>Hi/next<CR>
        " nn _        <Cmd>Hi/previous<CR>
        " nn f<Left>  <Cmd>Hi/older<CR>
        " nn f<Right> <Cmd>Hi/newer<CR>
        
        " command abbreviations
        " ca HL Hi:load
        " ca HS Hi:save
        
        " directory to store highlight files
        " let HiKeywords = '~/.vim/after/vim-highlighter'
        
        " highlight colors
        " hi HiColor21 ctermfg=52  ctermbg=181 guifg=#8f5f5f guibg=#d7cfbf cterm=bold gui=bold
        " hi HiColor22 ctermfg=254 ctermbg=246 guifg=#e7efef guibg=#979797 cterm=bold gui=bold
        " hi HiColor30 ctermfg=none cterm=bold guifg=none gui=bold
"     } vim-highlighter Key Mappings

" >>  tagbar Key Mappings
"     {
        nnoremap <silent> <leader>tt :TagbarToggle<CR>
"     } tagbar Key Mappings

" >>  FZF Key Mappings
"     {
        nn <leader>fbb    <Cmd>Buffers<CR>
        nn <leader>ff    <Cmd>Files<CR>
        nn <leader>fl    <Cmd>Lines<CR>
        nn <leader>ft    <Cmd>Tags<CR>
        nn <leader>fbt    <Cmd>BTags<CR>
        nn <leader>fj    <Cmd>Jumps<CR>
        nn <leader>fh    <Cmd>History<CR>
"     } FZF Key Mappings

"   } // Plugin Key Mappings
" } // Key Mappings

" ================= Auto Commands ====================
" {
" > General Auto Commands
"   {
      function! ResCur()
          if line("'\"") <= line("$")
              silent! normal! g`"
              return 1
          endif
      endfunction

      augroup resCur
          autocmd!
          autocmd BufWinEnter * call ResCur()
      augroup END
"   } // General Auto Commands
" } // Auto Commands
