if exists('g:loaded_scratch')
  finish
endif
let g:loaded_scratch = 1

command! -nargs=1 -complete=command Scratch call scratch#open(<q-args>, <q-mods>)

function! s:NewScratch()
lua << EOF
  local scratch_buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_open_win(scratch_buf, true, {
    vertical = true,
  })
EOF
endfunction

command! NewScratch :call s:NewScratch()
