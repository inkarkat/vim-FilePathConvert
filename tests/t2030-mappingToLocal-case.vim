" Test converting mapped URLs with differing case to absolute paths.

call vimtest#SkipAndQuitIf(! ingo#fs#path#IsCaseInsensitive(g:testdir), 'Need case-insensitive file system')

edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(4)

call vimtap#file#Is(FilePathConvert#ToLocal('http://testwebserver.org/INSTANCE/prod001.txt'), g:testdir . '/testdata/001/prod/prod001.txt', 'http to absolute, case difference in path')
call vimtap#file#Is(FilePathConvert#ToLocal('http://testwebserver.org/instance/PROD001.TXT'), g:testdir . '/testdata/001/prod/PROD001.TXT', 'http to absolute, case difference in filename')
call vimtap#file#Is(FilePathConvert#ToLocal('//stagesrv001.local/STAGE/dev001.txt'), g:testdir . '/testdata/001/dev/dev001.txt', 'UNC to absolute, case difference in path')
call vimtap#file#Is(FilePathConvert#ToLocal('//stagesrv001.local/STAGE/DEV001.TXT'), g:testdir . '/testdata/001/dev/DEV001.TXT', 'UNC to absolute, case difference in both')

call vimtest#Quit()
