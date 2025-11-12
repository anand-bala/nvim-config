
if exists("current_compiler") | finish | endif
let current_compiler = "ty"

let s:cpo_save = &cpo
set cpo&vim

" CompilerSet makeprg=ty
exe 'CompilerSet makeprg=' .. escape(
      \ 'ty check '
      \ ..'--output-format concise' 
      \ ..get(b:, 'ty_makeprg_params', get(g:, 'ty_makeprg_params', '')),
      \ ' \|"')
CompilerSet errorformat=%f:%l:%c:\ %t%*\\i%m

let &cpo = s:cpo_save
unlet s:cpo_save

