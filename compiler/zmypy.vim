
if exists("current_compiler") | finish | endif
let current_compiler = "zmypy"

let s:cpo_save = &cpo
set cpo&vim

" CompilerSet makeprg=zmypy
exe 'CompilerSet makeprg=' .. escape('zmypy --show-column-numbers '
      \ ..get(b:, 'zmypy_makeprg_params', get(g:, 'zmypy_makeprg_params', '--strict --ignore-missing-imports')),
      \ ' \|"')
CompilerSet errorformat=%f:%l:%c:\ %t%*[^:]:\ %m

let &cpo = s:cpo_save
unlet s:cpo_save
