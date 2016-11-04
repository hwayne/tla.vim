setlocal formatoptions-=t formatoptions+=crlj
setlocal foldmethod=syntax
setlocal comments=b:\\*

if exists("g:tla_functions")
  finish
endif
let g:tla_functions=1

function! s:TlaTranslate()
  execute "! java pcal.trans %"
endfunction

function! s:TlaParse()
  execute "! java tla2sany.SANY %"
endfunction

command! TlaTranslate call s:TlaTranslate()
command! TlaParse call s:TlaParse()
