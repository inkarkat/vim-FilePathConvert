" Test converting mapped URLs to absolute paths with query.

edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(3)

let g:IngoLibrary_ConfirmChoices = [g:testdir . '/testdata/001/dev/sub/lala.txt',  '/var/server/subgroup/lala.txt']
call vimtap#file#Is(FilePathConvert#ToLocal('//stagesrv001.local/subaccess/lala.txt'), g:testdir . '/testdata/001/dev/sub/lala.txt', 'UNC to queried absolute #1')
call vimtap#file#Is(FilePathConvert#ToLocal('//stagesrv001.local/subaccess/lala.txt'), '/var/server/subgroup/lala.txt', 'UNC to queried absolute #2')

let g:IngoLibrary_ConfirmChoices = [0]
call vimtap#err#Throws('Aborted', "call FilePathConvert#ToLocal('//stagesrv001.local/subaccess/lala.txt')", 'user abort')

call vimtest#Quit()
