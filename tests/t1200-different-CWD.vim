" Test converting with different CWDs.

function! s:Test()
    call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/testdata/001/prod/prod001.txt'), '../prod/prod001.txt', 'to local from ' . getcwd())
    call vimtap#file#Is(FilePathConvert#ToGlobal('../prod/prod001.txt'), g:testdir . '/testdata/001/prod/prod001.txt', 'to global from ' . getcwd())
endfunction
let g:FilePathConvert_UrlMappings = {}
edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(10)

call s:Test()

cd testdata/001
call s:Test()

cd dev
call s:Test()

cd $VIM
call s:Test()

set autochdir
execute 'edit' expand('<sfile>:p:h') . '/testdata/001/prod/prod001.txt'
call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/testdata/001/dev/dev001.txt'), '../dev/dev001.txt', 'to local from ' . getcwd())
call vimtap#file#Is(FilePathConvert#ToGlobal('../dev/dev001.txt'), g:testdir . '/testdata/001/dev/dev001.txt', 'to global from ' . getcwd())

call vimtest#Quit()
