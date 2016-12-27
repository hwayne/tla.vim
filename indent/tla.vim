" File: tla.vim
" Author: Hillel Wayne
" Description: Indent file for TLA+
" Last Modified: Wat

" This is both super elegant and way too slow.

if exists("b:did_indent")
   finish
endif

let b:did_indent = 1
let s:cpo_save = &cpo
set cpo&vim

setlocal indentexpr=TlaIndent()
setlocal indentkeys+=<:>,=end,=begin,=do,=or
"setlocal
 
let s:tla_open_scopes = [] " LET-IN, IF-THEN, CASE
let s:tla_closed_scopes = []
"  \ {'region': 'tlaSetRegion', 'start': 'tlaStartSet', 'end': 'tlaEndSet'},
"  \ {'region': 'tlaFunctionRegion', 'start': 'tlaStartFunction', 'end': 'tlaEndFunction'},
let s:pluscal_scopes = [ 
  \ {'region': 'pluscalBeginRegion', 'start': 'pluscalStartBegin', 'end': 'pluscalEndBegin'},
  \ {'region': 'pluscalIfRegion', 'start': 'pluscalStartIf', 'end': 'pluscalEndIf', 'mid': 'pluscalElse'},
  \ {'region': 'pluscalEitherRegion', 'start': 'pluscalStartEither', 'end': 'pluscalEndEither', 'mid': 'pluscalOr'},
  \ {'region': 'pluscalDoRegion', 'start': 'pluscalStartDo', 'end': 'pluscalEndDo'},
  \ ]

function! s:SyntaxStackAt(line, column)
  "We only really care about the name of the syntax stack
  "That's the only thing Vim will give us other than colors
  return map(synstack(a:line, a:column), 'synIDattr(v:val, "name")')
endfunction

function! s:SyntaxRegionsAt(line, column)
  return filter(s:SyntaxStackAt(a:line, a:column), 'v:val  =~ "Region"')
endfunction

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


" Returns index of first character in line with match
" _and_ the same region stack. For /\ and \/.
function! s:LineMatchesSyntaxWithRegion(linenum, match, regions)
  let columns = len(getline(a:linenum))
  for i in range(1, columns)
    if s:SyntaxStackAt(a:linenum, i)[-1] ==# a:match && s:SyntaxRegionsAt(a:linenum, i) == a:regions
      return i
    end if
  endfor
  return 0
endfunction

" Each line has a 'region signature'. The end matchgroup is the same as the
" start matchgroup, except that the the start has one extra 'region'
" corresponding to its start.
function! s:LineStartOfRegion(start, signature)
  " v:lnum - 1 is a hack to make this work more easily with labels
  for lineNum in reverse(range(1, v:lnum - 1))
    let region_start = s:LineMatchesSyntax(lineNum, a:start)
    if region_start && s:SyntaxRegionsAt(lineNum, region_start) == a:signature
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
    " Test we're in a region we need to unindent
    " Since tags also create indents, we have to match to the start of the
    " scope, not just deindent by one.
    " TODO DRY this up
    let end_scope_col = s:LineMatchesSyntax(v:lnum, scope["end"])
    if end_scope_col
      let start_of_region = s:LineStartOfRegion(scope["start"], s:SyntaxRegionsAt(v:lnum, end_scope_col) + [scope["region"]])
      return indent(start_of_region)
    endif

    let mid_scope_col = s:LineMatchesSyntax(v:lnum, get(scope, "mid", "NULL"))
    if mid_scope_col
      let start_of_region = s:LineStartOfRegion(scope["start"], s:SyntaxRegionsAt(v:lnum, mid_scope_col) + [])
      return indent(start_of_region)
    endif

    " Test we're in a region we need to indent
    if s:InSyntaxRegion(scope["region"]) && (s:LineMatchesSyntax(previousNum, scope["start"]) || s:LineMatchesSyntax(previousNum, get(scope, "mid", "NULL") ))
      return indent(previousNum) + &tabstop
    endif
  endfor

  "Tagtest!
  " This makes sure that there's only one level of tag indentation per region
  " TODO only if the start of a line?
  let label_col = s:LineMatchesSyntax(v:lnum, "pluscalLabel")
  if label_col
      let last_tagged_line = s:LineStartOfRegion("pluscalLabel", s:SyntaxRegionsAt(v:lnum, label_col) + [])
      if last_tagged_line
        return indent(last_tagged_line)
      endif
  endif
" tlaBinaryOperator
  " Tags create subindentations
  if s:LineMatchesSyntax(previousNum, "pluscalLabel")
    return indent(previousNum) + &tabstop
  endif

  " TLA SECTION
  " We assume an empty line is a sign the operator is complete, and so we can
  " assume it's back to square zero.

  if previousNum != v:lnum - 1
    return 0
  endif

  " /\ \/ : matching
  " Match indentation to /\ with same region
  let logic_col = s:LineMatchesSyntaxWithRegion(previousNum, "tlaBinaryOperator", s:SyntaxRegionsAt(line('.'), col('.')))
  if logic_col
    return logic_col - 1
  endif

  return indent(previousNum)
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
