; doc-strings
((expression_statement (string (string_content) @injection.content))
 (#set! injection.language "markdown"))

; ((comment) @injection.content
;            (#lua-match? @injection.content "^#: ")
;            (#offset! @injection.content 0 3 0 0)
;            (#set! injection.language "markdown"))
