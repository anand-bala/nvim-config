if exists('current_compiler')
  finish
endif
let s:ninja_exe = executable("ninja") 
      \? "ninja"
      \: (executable("ninja-build")
      \? "ninja-build"
      \: ''
      \)
" Make sure we have a ninja executable
if empty(s:ninja_exe)
  echoerr "Ninja not found"
  finish
endif

let current_compiler = "ninja"

" vint: -ProhibitAbbreviationOption
let s:save_cpo = &cpo
set cpo&vim
" vint: +ProhibitAbbreviationOption

let s:ninja_build_dir = exists('g:ninja_makeprg_builddir') ? g:ninja_makeprg_builddir : "build"

execute 'CompilerSet makeprg=ninja\ -C\ '.escape(s:ninja_build_dir, ' \|"').'\ $*'

unlet s:ninja_build_dir
unlet s:ninja_exe

" vint: -ProhibitAbbreviationOption
let &cpo = s:save_cpo
unlet s:save_cpo
" vint: +ProhibitAbbreviationOption
