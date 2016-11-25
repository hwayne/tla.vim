" File: tla.vim
" Author: Hillel Wayne
" Description: Indent file for TLA+
" Last Modified: Buffer overrun

if exists("b:did_indent")
  " finish
endif

let b:did_indent = 1
let s:cpo_save = &cpo
set cpo&vim

setlocal indentkeys+=:,=end,=begin,=do
setlocal indentexpr=TlaIndent()

" TODO deindents for pluscalOr and pluscalElsif
let s:pluscal_scopes = [ 
  \ {'region': 'pluscalBeginRegion', 'start': 'pluscalStartBegin', 'end': 'pluscalEndBegin'},
  \ {'region': 'pluscalNestRegion', 'start': 'pluscalStartNest', 'end': 'pluscalEndNest'},
  \ ]

function! s:SyntaxStackAt(line, column)
  "We only really care about the name of the syntax stack
  "That's the only thing Vim will give us other than colors
  return map(synstack(a:line, a:column), 'synIDattr(v:val, "name")')
endfunction

" Helper function
function! s:SyntaxRegionsAt(line, column)
  return filter(s:SyntaxStackAt(a:line, a:column), 'v:val  =~ "Region"')
endfunction

" This will always return the outermost region
" synstack orders broadest first
function! s:InSyntaxRegion(region)
  return index(s:SyntaxStackAt(line("."), col(".")), a:region) != -1
endfunction

" Returns index of first character in line 'match' region
" TODO jump by word to make this more performant
function! s:LineMatchesSyntax(linenum, match)
  let columns = len(getline(a:linenum))
  for i in range(1, columns)
    if s:SyntaxStackAt(a:linenum, i)[-1] ==# a:match
      return i
    end if
  endfor
  return 0
endfunction

" Each line has a 'region signature'. The end matchgroup is the same as the
" start matchgroup, except that the the start has one extra 'region'
" corresponding to its start.
function! s:LineStartOfRegion(scope, signature)
  for lineNum in reverse(range(1, v:lnum))
    let region_start = s:LineMatchesSyntax(lineNum, a:scope["start"])
    if region_start && s:SyntaxRegionsAt(lineNum, region_start) == a:signature + [a:scope["region"]]
      return lineNum
    endif
  endfor
  return 0
endfunction

function! TlaIndent()
  let line = getline(v:lnum)

  " First nonblank line at or above this
  let previousNum = prevnonblank(v:lnum - 1)

  """ PLUSCAL SECTION
  " We handle this after TLA+ so that if we have TLA+ in our PlusCal
  " We'll add on their rules instead!
  for scope in s:pluscal_scopes
    " Test we're in a region we need to indent
    " TODO should this go after the end scope test?
    if s:InSyntaxRegion(scope["region"]) && s:LineMatchesSyntax(previousNum, scope["start"])
      return indent(previousNum) + &tabstop
    endif

    " Test we're in a region we need to unindent
    " Since tags also create indents, we have to match to the start of the
    " scope, not just deindent by one.
    let end_scope_col = s:LineMatchesSyntax(v:lnum, scope["end"])
    if end_scope_col != 0
      let start_of_region = s:LineStartOfRegion(scope, s:SyntaxRegionsAt(v:lnum, end_scope_col))
      return indent(start_of_region)
    endif
  endfor

  "Tagtest!
  "TODO tags should match indentation of previous tag in same scope
  if s:LineMatchesSyntax(previousNum, "pluscalLabel")
    return indent(previousNum) + &tabstop
  endif

  return indent(previousNum)
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
