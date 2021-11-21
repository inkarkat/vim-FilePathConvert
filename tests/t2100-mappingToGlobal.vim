" Test converting absolute paths to mapped URLs.

edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(3)

call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/testdata/001/prod/prod001.txt'), 'http://testwebserver.org/instance/prod001.txt', 'absolute to http')
call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/testdata/001/dev/dev001.txt'), '//stagesrv001.local/stage/dev001.txt', 'absolute to UNC')
call vimtap#file#Is(FilePathConvert#ToGlobal('/var/server/subgroup/lala.txt'), '//stagesrv001.local/subaccess/lala.txt', 'one of absolute to UNC')

call vimtest#Quit()
