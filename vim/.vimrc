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
  Plug 'will133/vim-dirdiff'
call plug#end()
" } // Plugins

" ================= Settings ====================
" Initialize directories {
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    " To specify a different directory in which to place the vimbackup,
    " vimviews, vimundo, and vimswap files/directories, add the following to
    " your .vimrc.before.local file:
    "   let g:spf13_consolidated_directory = <full path to desired directory>
    "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
    if exists('g:spf13_consolidated_directory')
        let common_dir = g:spf13_consolidated_directory . prefix
    else
        let common_dir = parent . '/.' . prefix
    endif

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()
" }
" {
" > Use local options if available
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }
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

      set spell                       " Spell checking on
      set hidden                      " Allow buffer switching without saving

      set list
      set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
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

" >>  fzf.vim Settings
"     {
        let g:fzf_tags_command = 'ctags -R --fields=+im -I INFERENCE_ENGINE_API_CLASS,TORCH_API,SYN_API_CALL --C-kinds=+p --C++-kinds=+p'
"     } // fzf.vim settings

"   } // Plugin Settings
" } // Settings

" =================== Commands ======================
" {
" > General Commands
"   {
      "let g:my_tags_path = {
      "    \ 'py' : '',
      "    \ }

      " Add tags file to &tags {
      function! s:AddTags(tagName)
          if exists('g:my_tags_path') && has_key(g:my_tags_path, a:tagName)
              call s:AddTagsByPath(g:my_tags_path[a:tagName])
          else
              if !exists('g:my_tags_path')
                  echomsg 'warning: g:my_tags_path not defined'
              endif

              call s:AddTagsByPath(a:tagName)
          endif

          echomsg '&tags=' . &tags
      endfunction
      "}

      " Add tags file to &tags {
      function! s:AddTagsByPath(tagPath)
          if strlen(a:tagPath) == 0
              return
          endif

          if stridx(&tags, a:tagPath) == -1
              if strlen(&tags) == 0
                  let &tags = a:tagPath
              else
                  let &tags = &tags . "," . a:tagPath
              endif
          endif
      endfunction
      "}

      " Remove tags file from &tags {
      function! s:RemoveTags(tagName)
          if exists('g:my_tags_path') && has_key(g:my_tags_path, a:tagName)
              call s:RemoveTagsByPath(g:my_tags_path[a:tagName])
          else
              if !exists('g:my_tags_path')
                  echomsg 'warning: g:my_python_tags_path not defined'
              endif

              call s:RemoveTagsByPath(a:tagName)
          endif

          echomsg '&tags=' . &tags
      endfunction
      "}

      " Remove tags file from &tags {
      function! s:RemoveTagsByPath(tagPath)
          let tagPathIndex = stridx(&tags, a:tagPath)
          if tagPathIndex != -1
              let tagPathEndIndex = tagPathIndex + strlen(a:tagPath)
              let tagPathSeg1 = strpart(&tags, 0, tagPathIndex)
              let tagPathSeg2 = strpart(&tags, tagPathEndIndex)
              let tagPathSeg1Len = strlen(tagPathSeg1)
              if tagPathSeg1Len > 0 && strpart(tagPathSeg1, tagPathSeg1Len - 1) == ","
                  if tagPathSeg1Len == 1
                      let tagPathSeg1 = ""
                  else
                      let tagPathSeg1 = strpart(tagPathSeg1, 0, tagPathSeg1Len - 1)
                  endif
              endif
              let &tags = tagPathSeg1 . tagPathSeg2
          endif
      endfunction
      "}

      " Display &tags {
      function! s:ListTags()
          echomsg '&tags=' . &tags
      endfunction
      "}

      " Add/Remove/List &tags
      command! -nargs=1 -complete=file AddTags call <SID>AddTags(<f-args>)
      command! -nargs=1 -complete=file RemoveTags call <SID>RemoveTags(<f-args>)
      command! -nargs=0 ListTags call <SID>ListTags()
"   } // General Commands

" > Plugin Commands
"   {

" >>  vim-fzf commands
"     {
"       [opt, query, dir]
        function! s:FZF_Ag_w_args(...)
            let args = copy(a:000)
            if len(args) == 2
                call fzf#vim#ag(args[1], args[0], fzf#vim#with_preview(), 0)
            elseif len(args) == 3
                call fzf#vim#ag(args[1], args[0], fzf#vim#with_preview({"dir" : args[2]}), 0)
            endif
        endfunction
        command! -bang -nargs=* Agg call <SID>FZF_Ag_w_args(<f-args>)
"     } vim-fzf commands
"   } Plugin Commands
" }

" ================= Key Mappings ====================
" {
" > General Key Mappings
"   {
      let mapleader = ','
      inoremap <silent> jk <Esc>l

      " for easy resize window
      nnoremap <C-w>++ 10<C-w>+
      nnoremap <C-w>-- 10<C-w>-
      nnoremap <C-w>>> 10<C-w>>
      nnoremap <C-w><< 10<C-w><
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
        function! s:FZF_Ag_cword()
            call fzf#vim#ag(expand('<cword>'), fzf#vim#with_preview(), 0)
        endfunction

        nn <leader>fbb   <Cmd>Buffers<CR>
        nn <leader>ff    <Cmd>Files<CR>
        nn <leader>fl    <Cmd>Lines<CR>
        nn <leader>ft    <Cmd>Tags<CR>
        nn <leader>ftc   :Tags <c-r>=expand('<cword>')<CR><CR>
        nn <leader>fbt   <Cmd>BTags<CR>
        nn <leader>fbc   :BTags <c-r>=expand('<cword>')<CR><CR>
        nn <leader>fj    <Cmd>Jumps<CR>
        nn <leader>fh    <Cmd>History<CR>
        nn <leader>fag   :Ag <c-r>=expand('<cword>')<CR><CR>
        nn <leader>faw   :Agg -w <c-r>=expand('<cword>')<CR><CR>
        imap <c-x><c-k> <plug>(fzf-complete-word)
        imap <c-x><c-f> <plug>(fzf-complete-path)
        imap <c-x><c-l> <plug>(fzf-complete-line)
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
