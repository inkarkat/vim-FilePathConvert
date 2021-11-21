" Test converting mapped URLs to absolute paths.

edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(4)

call vimtap#file#Is(FilePathConvert#ToLocal('http://testwebserver.org/instance/prod001.txt'), g:testdir . '/testdata/001/prod/prod001.txt', 'http to absolute')
call vimtap#file#Is(FilePathConvert#ToLocal('//stagesrv001.local/stage/dev001.txt'), g:testdir . '/testdata/001/dev/dev001.txt', 'UNC to absolute')

call vimtap#file#Is(FilePathConvert#ToLocal('//dropbox.com/asdf/mappedFile.txt'), g:testdir . '/testdata/001/file.txt', 'UNC file to absolute')
call vimtap#file#Is(FilePathConvert#ToLocal('http://www.dropbox.com/asdf/mappedFile.txt'), g:testdir . '/testdata/001/file.txt', 'http file to absolute')

call vimtest#Quit()
