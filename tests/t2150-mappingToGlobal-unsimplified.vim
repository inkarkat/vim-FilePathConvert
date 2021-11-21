" Test converting unsimplified absolute paths to mapped URLs.

edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(2 + (ingo#os#IsWinOrDos() ? 1 : 0))

call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/./testdata/001/prod/prod001.txt'), 'http://testwebserver.org/instance/prod001.txt', '/./ absolute to http')
call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/testdata/002/../001/dev/dev001.txt'), '//stagesrv001.local/stage/dev001.txt', '/002/../ absolute to UNC')
if ingo#os#IsWinOrDos()
    let g:testdir = tr(substitute(g:testdir, '^\a:', '', ''), '\', '/')
    call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/testdata/001/prod/prod001.txt'), 'http://testwebserver.org/instance/prod001.txt', 'absolute without drive letter to http')
endif

call vimtest#Quit()
