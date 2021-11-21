" Test converting unsimplfied absolute paths to local paths.

let g:FilePathConvert_UrlMappings = {}
edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(2 + (ingo#os#IsWinOrDos() ? 1 : 0))

call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/./testdata/001/dev/dev001.txt'), 'dev001.txt', '/./testdata/001/dev/dev001.txt')
call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/testdata/002/../001/dev/dev001.txt'), 'dev001.txt', '/testdata/002/../001/dev/dev001.txt')
if ingo#os#IsWinOrDos()
    let g:testdir = tr(substitute(g:testdir, '^\a:', '', ''), '\', '/')
    call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/testdata/001/dev/dev001.txt'), 'dev001.txt', '/testdata/001/dev/dev001.txt without drive letter')
endif

call vimtest#Quit()
