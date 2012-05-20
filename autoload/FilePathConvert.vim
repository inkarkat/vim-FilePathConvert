" FilePathConvert.vim: Convert filespec between absolute, relative, and URL formats.
"
" DEPENDENCIES:
"   - ingointegration.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	002	18-May-2012	Pass baseDir and pathSeparator into the
"				functions.
"				Improve variable names.
"				Handle implicit current drive letter in absolute
"				paths.
"	001	18-May-2012	file creation

function! FilePathConvert#FileSelection()
    call ingointegration#SelectCurrentRegexp('v', '\f\+', line('.'))
    return 1
endfunction

function! s:GetType( filespec )
    if a:filespec =~# '^[/\\][^/\\]' || ((has('win32') || has('win64')) && a:filespec =~? '^\a:[/\\]')
	return 'abs'
    elseif a:filespec =~? '^[a-z+.-]\+:' " RFC 1738
	return 'url'
    else
	return 'rel'
    endif
endfunction

function! s:GetBaseDir( filespec )
    let l:dir = a:filespec
    while fnamemodify(l:dir, ':h') !=# l:dir
	let l:dir = fnamemodify(l:dir, ':h')
    endwhile
    return l:dir
endfunction

function! FilePathConvert#RelativeToAbsolute( baseDir, filespec )
    if s:GetType(a:filespec) !=# 'rel'
	throw 'Not a relative file: ' . a:filespec
    endif

    if expand('%:h') !=# '.'
	" Need to change into the file's directory first to get glob results
	" relative to the file.
	let l:save_cwd = getcwd()
	chdir! %:p:h
    endif
    try
	let l:relativeFilespec = ingofile#NormalizePathSeparators(a:filespec)
	let l:absoluteFilespec = fnamemodify(l:relativeFilespec, ':p')
"****D echomsg '****' string(a:baseDir) string(l:absoluteFilespec)
	if empty(a:baseDir)
	    throw 'Could not determine base dir!'
	elseif strpart(l:absoluteFilespec, 0, len(a:baseDir)) ==# a:baseDir
	    return l:absoluteFilespec
	else
	    throw 'Link to outside of base dir: ' . l:absoluteFilespec
	endif
    finally
	if exists('l:save_cwd')
	    execute 'chdir!' escapings#fnameescape(l:save_cwd)
	endif
    endtry
endfunction

function! s:GetDrive( baseDir, filespec )
    let l:drive = matchstr(a:filespec, '^\a:')
    return (empty(l:drive) ? a:baseDir[0:1] : l:drive)
endfunction
function! s:NormalizeBaseDir( baseDir, filespec )
    let l:drive = matchstr(a:filespec, '^\a:')
    return (empty(l:drive) ? ingofile#CombineToFilespec(a:baseDir, a:filespec) : a:filespec)
endfunction
function! s:NormalizeBase( filespec )
    return substitute(a:filespec, '^\a:', '', '')
endfunction
function! s:IsOnDifferentRoots( filespecA, filespecB, pathSeparator )
    if ! (has('win32') || has('win64'))
	return 0
    endif

    if matchstr(a:filespecA, '^\a:') !=? matchstr(a:filespecB, '^\a:')
	return 1
    endif

    let l:ps = escape(a:pathSeparator, '\')
    if matchstr(a:filespecA, printf('^%s%s[^%s]\+', l:ps, l:ps, l:ps)) !=? matchstr(a:filespecB, printf('^%s%s[^%s]\+', l:ps, l:ps, l:ps))
	return 1
    endif

    return 0
endfunction
function! s:HeadAndRest( filespec, pathSeparator )
    let l:ps = escape(a:pathSeparator, '\')
    return [matchstr(a:filespec, printf('%s[^%s]*', l:ps, l:ps)), matchstr(a:filespec, printf('%s[^%s]*\zs.*$', l:ps, l:ps))]
endfunction
function! FilePathConvert#AbsoluteToRelative( baseDir, filespec, pathSeparator )
    if empty(a:baseDir)
	throw 'Could not determine base dir!'
    endif

    let l:currentDirspec = expand('%:p:h') . a:pathSeparator
    if strpart(l:currentDirspec, 0, len(a:baseDir)) !=# a:baseDir
	throw 'File outside of base dir: ' . a:baseDir
    endif

    " To generate the relative filespec, we need the dirspec part of the current
    " buffer, and the absolute source filespec.
    let l:absoluteFilespec = ingofile#NormalizePathSeparators(s:NormalizeBaseDir(s:GetBaseDir(getcwd()), a:filespec), a:pathSeparator)
"****D echomsg '****' string(a:baseDir) string(l:absoluteFilespec) string(l:currentDirspec)
    if s:IsOnDifferentRoots(l:currentDirspec, l:absoluteFilespec, a:pathSeparator)
	throw 'File has a different root'
    endif
    " Determine the directory where both diverge by stripping the head directory
    " off both if they are identical.
    let l:current  = s:NormalizeBase(l:currentDirspec)
    let l:absolute = s:NormalizeBase(l:absoluteFilespec)
    while 1
"****D echomsg '####' string(l:current) string(l:absolute)
	let [l:currentHead , l:currentRest ] = s:HeadAndRest(l:current , a:pathSeparator)
	let [l:absoluteHead, l:absoluteRest] = s:HeadAndRest(l:absolute, a:pathSeparator)
"****D echomsg '####' string(l:currentHead) string(l:absoluteHead)
	if l:currentHead ==# l:absoluteHead
	    let l:current  = l:currentRest
	    let l:absolute = l:absoluteRest
	else
	    break
	endif
    endwhile
"****D echomsg '****' string(l:current) string(l:absolute)
    " The remaining dirspec part of the current buffer must be traversed up to go
    " to the directory where both diverge. From there, traverse down what
    " remains of the stripped source filespec.
    let l:dirUp = substitute(l:current[1:], printf('[^%s]\+', escape(a:pathSeparator, '\')), '..', 'g')
    let l:relativeFilespec = l:dirUp . l:absolute[1:]
"****D echomsg '****' string(l:dirUp) string(l:relativeFilespec)
    return l:relativeFilespec
endfunction

function! FilePathConvert#Do( text )
    let l:type = s:GetType(a:text)
    let l:baseDir = s:GetBaseDir(expand('%:p:h'))
    if l:type ==# 'rel'
	return FilePathConvert#RelativeToAbsolute(l:baseDir, a:text)
    elseif l:type ==# 'abs'
	return FilePathConvert#AbsoluteToRelative(l:baseDir, a:text, ingofile#PathSeparator())
    elseif l:type ==# 'url'
	throw 'TODO: not yet implemented'
    else
	throw 'ASSERT: Unknown type ' . string(l:type)
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
