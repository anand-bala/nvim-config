" File: lintcomp.vim
" Author: Anand Balakrishnan
" Description: Configuration for Linter and Autocomplete

" -- ALE config
" {{
let g:ale_set_signs = 1
let g:ale_set_highlights = 0
" Set ALE explicit so that I need to enable only the select few plugins I like
" in ALE (proselint, etc.)
let g:ale_linters_explicit = 1

let g:ale_linters = {
      \ 'tex' : ['proselint', 'lacheck', 'chktex'],
      \ 'markdown' : ['proselint'],
      \ 'rst': ['proselint']
      \ }

let g:ale_fixers = {
      \ 'javascript': ['eslint'],
      \ 'haskell': ['hindent', 'stylish-haskell'],
      \ }

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" }}

" -- ctags settings
" {{
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+aimS',
      \ ]
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.git': 'fd -L -t f',
      \   '.hg': 'fd -L -t f',
      \ },
      \}
" }}

" -- UltiSnips
" {{
let g:UltiSnipsExpandTrigger = '<TAB>'
let g:UltiSnipsJumpForwardTrigger = '<c-n>'
let g:UltiSnipsJumpBackwardTrigger = '<c-p>'
let g:UltiSnipsRemoveSelectModeMappings = 0
" }}

" -- Vista
" {{{
let g:vista_default_executive = 'ctags'
let g:vista_finder_alternative_executives = ['nvim_lsp', 'ale']
let g:vista_sidebar_width = 40
" }}}

" -- nvim-lsp completions-nvim diagnostics-nvim
" {{{
" Load default LSP configuration
lua require("lsp-config").setup()

let g:completion_trigger_character = ['.', '::']
let g:completion_confirm_key = "\<TAB>"
let g:completion_chain_complete_list = {
            \ 'default' : {
            \   'default': [
            \       {'complete_items': ['lsp', 'snippet']},
            \       {'mode': '<c-p>'},
            \       {'mode': '<c-n>'}],
            \   'comment': [],
            \   'string' : [
            \       {'complete_items': ['path']}]
            \   },
            \ 'markdown' : {
            \   'default': [
            \       {'mode': 'spell'}],
            \   'comment': [],
            \   },
            \}

command! LspShowLineDiagnostic lua require'diagnostic.util'.show_line_diagnostics()<CR>

" diagnostic-nvim
let g:diagnostic_enable_virtual_text = 0
let g:diagnostic_virtual_text_prefix = ' '
let g:diagnostic_trimmed_virtual_text = 30
let g:space_before_virtual_text = 5
let g:diagnostic_insert_delay = 1

" completion-nvim
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_max_items = 10
let g:completion_enable_auto_paren = 1
let g:completion_timer_cycle = 200

" }}}
