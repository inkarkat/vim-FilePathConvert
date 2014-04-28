" FilePathConvert.vim: Convert filespec between absolute, relative, and URL formats.
"
" DEPENDENCIES:
"   - FilePathConvert.vim autoload script
"
" Copyright: (C) 2012-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.10.006	28-Apr-2014	Add <Leader>sF variant that converts into more
"				global filespecs to support file:// URLs.
"   1.00.005	06-Mar-2014	TextTransformSelections.vim has been moved into
"				the TextTransform plugin.
"	004	28-Aug-2012	Rename algorithm function for better display by
"				SubstitutionsHelp.vim.
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

"- configuration ---------------------------------------------------------------

if ! exists('g:FilePathConvert_UrlMappings')
    let g:FilePathConvert_UrlMappings = {
    \   '//sake/install$': {'filespec': 'D:\install'},
    \   '//wotan/www': {'filespec': 'W:\'},
    \   'http://wotan/': {'filespec': 'W:\htdocs'},
    \}
endif


"- mappings --------------------------------------------------------------------

if v:version < 702 | runtime autoload/TextTransform/Selections.vim | runtime autoload/FilePathConvert.vim | endif  " The Funcref doesn't trigger the autoload in older Vim versions.
let s:fileSelection = [function('TextTransform#Selections#QuotedInSingleLine'), function('FilePathConvert#FileSelection')]
call TextTransform#MakeMappings('', '', 'FilePathConvert#ToLocal', s:fileSelection)
call TextTransform#MakeMappings('', '', 'FilePathConvert#ToGlobal', s:fileSelection)

if ! hasmapto('<Plug>TextTFilePathConvert#ToLocalLine', 'n')
    nmap <Leader>sf <Plug>TextTFilePathConvert#ToLocalLine
endif
if ! hasmapto('<Plug>TextTFilePathConvert#ToLocalVisual', 'x')
    xmap <Leader>sf <Plug>TextTFilePathConvert#ToLocalVisual
endif
if ! hasmapto('<Plug>TextTFilePathConvert#ToGlobalLine', 'n')
    nmap <Leader>sF <Plug>TextTFilePathConvert#ToGlobalLine
endif
if ! hasmapto('<Plug>TextTFilePathConvert#ToGlobalVisual', 'x')
    xmap <Leader>sF <Plug>TextTFilePathConvert#ToGlobalVisual
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
