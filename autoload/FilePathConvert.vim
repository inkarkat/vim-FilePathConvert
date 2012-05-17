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

function! s:GetBaseDir()
    let l:dir = expand('%:p:h')
    while fnamemodify(l:dir, ':h') !=# l:dir
	let l:dir = fnamemodify(l:dir, ':h')
    endwhile
    return l:dir
endfunction

function! FilePathConvert#RelativeToAbsolute( filespec )
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
	let l:baseDirspec = s:GetBaseDir()
"****D echomsg '****' string(l:baseDirspec) string(l:absoluteFilespec)
	if empty(l:baseDirspec)
	    throw 'Could not determine base dir!'
	elseif strpart(l:absoluteFilespec, 0, len(l:baseDirspec)) ==# l:baseDirspec
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
function! FilePathConvert#AbsoluteToRelative( filespec, pathSeparator )
    let l:baseDirspec = s:GetBaseDir()
    if empty(l:baseDirspec)
	throw 'Could not determine base dir!'
    endif

    let l:absoluteDirspec = expand('%:p:h') . a:pathSeparator
    if strpart(l:absoluteDirspec, 0, len(l:baseDirspec)) !=# l:baseDirspec
	throw 'File outside of base dir: ' . l:baseDirspec
    endif

    " To generate the relative filespec, we need the dirspec part of the current
    " file starting from the base dir, and the absolute link filespec.
    let l:fromBaseDirspec = l:absoluteDirspec
    let l:absoluteFilespec = ingofile#NormalizePathSeparators(a:filespec)
"****D echomsg '****' string(l:baseDirspec) string(l:absoluteFilespec) string(l:fromBaseDirspec)
    if s:IsOnDifferentRoots(l:fromBaseDirspec, l:absoluteFilespec, a:pathSeparator)
	throw 'File has a different root'
    endif
    " Determine the directory where both diverge by stripping the head directory
    " off both if they are identical.
    let l:fromBase = l:fromBaseDirspec
    let l:absolute = l:absoluteFilespec
    while 1
"****D echomsg '####' string(l:fromBase) string(l:absolute)
	let [l:fromBaseHead, l:fromBaseRest] = s:HeadAndRest(l:fromBase, a:pathSeparator)
	let [l:absoluteHead, l:absoluteRest] = s:HeadAndRest(l:absolute, a:pathSeparator)
"****D echomsg '####' string(l:fromBaseHead) string(l:absoluteHead)
	if l:fromBaseHead ==# l:absoluteHead
	    let l:fromBase = l:fromBaseRest
	    let l:absolute = l:absoluteRest
	else
	    break
	endif
    endwhile
"****D echomsg '****' string(l:fromBase) string(l:absolute)
    " The remaining dirspec part of the current file must be traversed up to go
    " to the directory where both diverge. From there, traverse down what
    " remains of the stripped link filespec.
    let l:dirUp = substitute(l:fromBase[1:], printf('[^%s]\+', escape(a:pathSeparator, '\')), '..', 'g')
    let l:relativeFilespec = l:dirUp . l:absolute[1:]
"****D echomsg '****' string(l:dirUp) string(l:relativeFilespec)
    return l:relativeFilespec
endfunction

function! FilePathConvert#Do( text )
    let l:type = s:GetType(a:text)
    if l:type ==# 'rel'
	return FilePathConvert#RelativeToAbsolute(a:text)
    elseif l:type ==# 'abs'
	return FilePathConvert#AbsoluteToRelative(a:text, ingofile#PathSeparator())
    elseif l:type ==# 'url'
	throw 'TODO: not yet implemented'
    else
	throw 'ASSERT: Unknown type ' . string(l:type)
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
