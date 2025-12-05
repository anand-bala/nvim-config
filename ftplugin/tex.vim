let g:vimtex_mappings_enabled = 1
let g:vimtex_complete_enabled = 1
let g:vimtex_view_enabled = 1
let g:vimtex_format_enabled = 1
let g:vimtex_compiler_enabled = 1

let g:vimtex_quickfix_mode = 0

if !exists("g:vimtex_complete_bib")
  let g:vimtex_complete_bib  = {}
endif
let g:vimtex_complete_bib.info_fmt = "@author_short (@year), \"@title\""
" let g:vimtex_view_method = "zathura"
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

let g:vimtex_view_forward_search_on_start = 0
let g:vimtex_view_automatic = 0

let g:vimtex_toc_config = {
      \ 'split_pos': 'botright',
      \ 'fold_enable': 1,
\ }
let g:vimtex_toc_show_preamble = 0

function! SetCompilerMethod(mainfile)
  if filereadable(a:mainfile)
    for line in readfile(a:mainfile, '', 5)
      if line =~# '^%\s*arara'
        return 'arara'
      endif
    endfor
  endif

  return 'latexmk'
endfunction
let g:vimtex_compiler_method = 'SetCompilerMethod'
let g:vimtex_compiler_silent = 0

