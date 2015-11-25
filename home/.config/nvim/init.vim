" Set python interpreter path before every other thing
if has('mac')
    let g:python_host_prog = '/usr/local/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3'
else
    let g:python_host_prog = system('echo -n $(brew --prefix)') . '/bin/python'
    let g:python3_host_prog = system('echo -n $(brew --prefix)') . '/bin/python3'
endif
" Set vim-home
let g:vim_home = $HOME . '/.config/nvim/'
" Load plugins
execute 'source' g:vim_home . 'plugins.vim'
" Load basic settings
execute 'source' g:vim_home . 'basic.vim'
" Load key mapping
execute 'source' g:vim_home . 'keymap.vim'
" Load plugins settings
for f in split(glob(g:vim_home . 'pluginrc.d/*.vim'), '\n')
  execute 'source' f
endfor