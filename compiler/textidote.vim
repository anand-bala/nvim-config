"""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Copy from lervag/vimtex with minor modification  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists('current_compiler') | finish | endif
let current_compiler = 'textidote'

let s:cpo_save = &cpo
set cpo&vim

if executable("textidote")
  let s:textidote_cmd = 'textidote'
elseif exists('g:tex_textidote_jar')
      \ && filereadable(fnamemodify(g:tex_textidote_jar, ':p'))
  let s:textidote_cmd = 'java -jar '
        \ . shellescape(fnamemodify(g:tex_textidote_jar, ':p'))
else
  echoerr 'To use the textidote compiler, '
        \ . 'please set g:tex_textidote_jar to the path of textidote.jar!'
        \ . 'Or install textidote globally.'
  finish
endif

let &l:makeprg = s:textidote_cmd
      \ . ' --no-color --output singleline --check '
      \ . matchstr(&spelllang, '^\a\a') . ' %:S'

setlocal errorformat=
setlocal errorformat+=%f(L%lC%c-L%\\d%\\+C%\\d%\\+):\ %m
setlocal errorformat+=%-G%.%#

silent CompilerSet makeprg
silent CompilerSet errorformat

let &cpo = s:cpo_save
unlet s:cpo_save
