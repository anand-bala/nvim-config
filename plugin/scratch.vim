if exists('g:loaded_scratch')
  finish
endif
let g:loaded_scratch = 1

command! -nargs=1 -complete=command Scratch call scratch#open(<q-args>, <q-mods>)
