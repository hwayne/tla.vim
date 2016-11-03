if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif



" ---------------------------------------for TLA+------------------------------------
"highlight keywords
syn keyword tlaStatement		 CASE  OTHER  IF THEN  ELSE  LET IN
syn keyword tlaBoolean TRUE FALSE BOOLEAN 
syn keyword tlaNormalOperator	CHOOSE SUBSET UNION DOMAIN EXCEPT  ENABLE[D] ENABLE UNCHANGED 	 

syn keyword tlaFunc Nat Real Int Infinity Head SelectSeq SubSeq Append Len Seq Tail IsFiniteSet Cardinality	BagCardinality BagIn BagOfAll BagToSet BagUnion CopiesIn EmptyBag IsABag SetToBag SubBag RTBound RTnow now Print PrintT Assert JavaTime Permutations SortSeq 

syn keyword tlaModule MODULE EXTEND[S] INSTANCE WITH LOCAL
syn keyword tlaConstant CONSTANT[S] VARIABLE[S] ASSUME

syn keyword tla2Keyword THEOREM ACTION HAVE PICK SUFFICES ASSUMPTION HIDE PROOF TAKE AXIOM LAMBDA PROPOSITION TEMPORAL BY LEMMA PROVE USE COROLLARY NEW QED WITNESS DEF OBVIOUS RECURSIVE DEFINE OMITTED STATE DEFS

syntax region tlaComment start="(\*\( --algorithm\)\@!" end="\*)"
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
syn match tlaFairnessOperator  /[WS]F_\(<\)\{0,2\}\w\+\(>\)\{0,2\}/

syn region tlaTranslation start=/\\\* BEGIN TRANSLATION/ end=/\\\* END TRANSLATION/ fold
"-------------------------------- for TLA+ end--------------------------------
"
"-------------------------------- for PlusCal--------------------------------
syn keyword pluscalDeclaration contained variable[s]
syn keyword pluscalConditional contained or either with if then else elsif while do await
syn match pluscalConditional contained /end \(process\|algorithm\)\@!/
syn keyword pluscalReservedWods contained macro print procedure
syn match pluscalProcess contained /\(fair \)\=process/
syn match pluscalProcess contained /end process/
syn match pluscalProcess contained /begin/
"syn keyword pluscalToDo   call goto return contained
syn keyword pluscalDebug contained assert print skip
syn match pluscalLabel contained /[A-Z]\w*:/
syn cluster pluscalCluster contains=pluscalDeclaration,pluscalConditional,pluscalReservedWods,pluscalDebug,pluscalLabel,pluscalProcess

syn match pluscalMatchGroup /\((\* --\)\=\(end \)\=algorithm/
syn region pluscal start=/(\* --algorithm.*/ end="end algorithm; \*)" matchgroup=pluscalMatchGroup contains=ALL
syn region pluscalProcessScope start=/process[^;]/ end=/end process/ matchgroup=pluscalProcess contained containedin=pluscal contains=ALL
"-------------------------------- for PlusCal end--------------------------------



if version >= 508 
  if version < 508
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink tlaEnd            Comment
  HiLink tlaComment			Comment
  HiLink tlaSlashComment			Comment
  HiLink tlaFunc			Ignore
  HiLink tlaBoolean			Boolean
  HiLink tlaString			String
  HiLink tlaNumber			Number
  HiLink tlaNormalOperator			Operator
  HiLink tlaSetConditional			Operator
  HiLink tlaBinaryOperator			Operator
  HiLink tlaTemporalOperator Debug
  HiLink tlaStatement	Conditional
  HiLink tlaModule			Include
  HiLink tlaConstant			Define
  HiLink tlaFairnessOperator			Operator
  HiLink tla2Keyword        Keyword



  HiLink pluscalMatchGroup Function
  HiLink pluscalProcess Function
  HiLink pluscalLabel			Type
  HiLink pluscalShareKeyword Comment
  HiLink pluscalReservedWods Constant
  HiLink pluscalDeclaration Define
  HiLink pluscalConditional Conditional
  
  delcommand HiLink
endif

let b:current_syntax = "tla"

