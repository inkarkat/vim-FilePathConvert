" Test converting absolute paths with differing case to mapped URLs.

call vimtest#SkipAndQuitIf(! ingo#fs#path#IsCaseInsensitive(g:testdir), 'Need case-insensitive file system')

edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(4)

call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/TESTDATA/001/prod/prod001.txt'), 'http://testwebserver.org/instance/prod001.txt', 'absolute to http, case difference in path')
call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/testdata/001/prod/PROD001.TXT'), 'http://testwebserver.org/instance/PROD001.TXT', 'absolute to http, case difference in filename')
call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/TESTDATA/001/dev/dev001.txt'), '//stagesrv001.local/stage/dev001.txt', 'absolute to UNC, case difference in path')
call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/TESTDATA/001/dev/DEV001.TXT'), '//stagesrv001.local/stage/DEV001.TXT', 'absolute to UNC, case difference in both')

call vimtest#Quit()
