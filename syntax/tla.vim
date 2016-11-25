" vim: ft=vim:fdm=marker

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" TLA+ Syntax {{{
syn keyword tlaStatement		 CASE  OTHER  IF THEN  ELSE  LET IN
syn keyword tlaBoolean TRUE FALSE BOOLEAN 
syn keyword tlaNormalOperator	CHOOSE SUBSET UNION DOMAIN EXCEPT ENABLE[D] ENABLE UNCHANGED 	 

syn keyword tlaFunc Nat Real Int Infinity Head SelectSeq SubSeq Append Len Seq Tail IsFiniteSet Cardinality	BagCardinality BagIn BagOfAll BagToSet BagUnion CopiesIn EmptyBag IsABag SetToBag SubBag RTBound RTnow now Print PrintT Assert JavaTime Permutations SortSeq 

syn keyword tlaModule MODULE EXTEND[S] INSTANCE WITH LOCAL
syn keyword tlaConstant CONSTANT[S] VARIABLE[S] ASSUME

syn keyword tla2Keyword THEOREM ACTION HAVE PICK SUFFICES ASSUMPTION HIDE PROOF TAKE AXIOM LAMBDA PROPOSITION TEMPORAL BY LEMMA PROVE USE COROLLARY NEW QED WITNESS DEF OBVIOUS RECURSIVE DEFINE OMITTED STATE DEFS

" Negative lookahead prevents PlusCal algorithms from being matched
syntax region tlaComment start="(\*\( --algorithm\)\@!" end="\*)" contains=tlaComment
syntax match tlaSlashComment /\\\*.*/
syntax region tlaString  start=/"/ skip=/\\"/ end=/"/
syntax keyword tlaString STRING

syntax match tlaNumber /-\?\d\+/
syntax match tlaSetConditional /\\E/ 
syntax match tlaSetConditional /\\A/ 
"syntax match tlaSetConditional /=>/


syntax match tlaBinaryOperator /\\\// 
syntax match tlaBinaryOperator /\/\\/ 
syntax match tlaEnd /=\{4,\}/ 

syn match tlaTemporalOperator /\\EE/ 
syn match tlaTemporalOperator /\\AA/ 
syn match tlaTemporalOperator /\[\]/
syn match tlaTemporalOperator /[^<]<>/
syn match tlaTemporalOperator /\~>/
syn match tlaFairnessOperator /[WS]F_\(<\)\{0,2\}\w\+\(>\)\{0,2\}/

" Defined to enable hiding it
syn region tlaTranslation start=/\\\* BEGIN TRANSLATION/ end=/\\\* END TRANSLATION/ fold

" }}}

" PlusCal Syntax {{{
syn keyword pluscalDeclaration contained variable[s]
syn keyword pluscalConditional contained or either with if else elsif while await
syn keyword pluscalMethods contained macro procedure self define process
"syn match pluscalProcess contained /\(fair \)\=process/
"syn keyword pluscalToDo   call goto return contained
syn keyword pluscalDebug contained assert print skip
syn match pluscalLabel contained /[A-Z]\w*:/
syn cluster pluscalCluster contains=pluscalDeclaration,pluscalConditional,pluscalMethods,pluscalDebug,pluscalLabel,pluscalProcess

syn region pluscalRegion matchgroup=pluscalMatchGroup start=/(\* --algorithm/ end=/end algorithm/ contains=tla.*,@pluscalCluster

syn region pluscalBeginRegion matchgroup=pluscalStartBegin start=/begin/ matchgroup=pluscalEndBegin end=/end/ contained containedin=pluscalRegion contains=tla.*,@pluscalCluster
hi def link pluscalStartBegin pluscalMatchGroup
hi def link pluscalEndBegin   pluscalMatchGroup

syn region pluscalNestRegion matchgroup=pluscalStartNest start=/then\|do/ matchgroup=pluscalEndNest end=/end/ contained containedin=pluscalBeginRegion contains=tla.*,@pluscalCluster,pluscalNestRegion
hi def link plusCalStartNest pluscalConditional
hi def link plusCalEndNest   pluscalConditional

" pluscalDefineRegion
" pluscalVariablesRegion?
" pluscalEitherRegion
" pluscalIfRegion

" }}}

" Highlight {{{
hi def link tlaEnd                 Comment
hi def link tlaComment             Comment
hi def link tlaSlashComment        Comment
hi def link tlaFunc                Ignore
hi def link tlaBoolean             Boolean
hi def link tlaString              String
hi def link tlaNumber              Number
hi def link tlaNormalOperator      Operator
hi def link tlaSetConditional      Operator
hi def link tlaBinaryOperator      Operator
hi def link tlaTemporalOperator    Debug
hi def link tlaStatement           Conditional
hi def link tlaModule              Include
hi def link tlaConstant            Define
hi def link tlaFairnessOperator    Operator
hi def link tla2Keyword            Keyword

hi def link pluscalMatchGroup      Function
hi def link pluscalProcess         Function
hi def link pluscalMethods         Function
hi def link pluscalLabel           Type
hi def link pluscalDeclaration     Define
hi def link pluscalConditional     Conditional
" }}}
  
let b:current_syntax = "tla"
