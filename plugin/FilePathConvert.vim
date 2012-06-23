" FilePathConvert.vim: Convert filespec between absolute, relative, and URL formats.
"
" DEPENDENCIES:
"   - FilePathConvert.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	001	18-May-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_FilePathConvert') || (v:version < 700)
    finish
endif
let g:loaded_FilePathConvert = 1

let s:fileSelection = [function('TextTransformSelections#QuotedInSingleLine'), function('FilePathConvert#FileSelection')]
call TextTransform#MakeMappings('', '', 'FilePathConvert#Do', s:fileSelection)

if ! hasmapto('<Plug>TextTFilePathConvert#DoLine', 'n')
    nmap <Leader>sf <Plug>TextTFilePathConvert#DoLine
endif
if ! hasmapto('<Plug>TextTFilePathConvert#DoVisual', 'v')
    vmap <Leader>sf <Plug>TextTFilePathConvert#DoVisual
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
