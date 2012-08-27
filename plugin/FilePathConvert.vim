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
"	003	13-Aug-2012	FIX: Vim 7.0/1 need preloading of functions
"				referenced in Funcrefs.
"	002	24-Jun-2012	Don't define the <Leader>sf default mapping in
"				select mode, just visual mode.
"	001	18-May-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_FilePathConvert') || (v:version < 700)
    finish
endif
let g:loaded_FilePathConvert = 1

if v:version < 702 | runtime autoload/TextTransformSelections.vim | runtime autoload/FilePathConvert.vim | endif  " The Funcref doesn't trigger the autoload in older Vim versions.
let s:fileSelection = [function('TextTransformSelections#QuotedInSingleLine'), function('FilePathConvert#FileSelection')]
call TextTransform#MakeMappings('', '', 'FilePathConvert#Do', s:fileSelection)

if ! hasmapto('<Plug>TextTFilePathConvert#DoLine', 'n')
    nmap <Leader>sf <Plug>TextTFilePathConvert#DoLine
endif
if ! hasmapto('<Plug>TextTFilePathConvert#DoVisual', 'v')
    xmap <Leader>sf <Plug>TextTFilePathConvert#DoVisual
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
