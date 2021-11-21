" Test converting absolute paths to mapped URLs with query.

edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(5)

let g:IngoLibrary_ConfirmChoices = map(['//stagesrv001.local/stage/sub/lala.txt', '//stagesrv001.local/subaccess/lala.txt'], 'ingo#fs#path#Normalize(v:val)')
call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/testdata/001/dev/sub/lala.txt'), '//stagesrv001.local/stage/sub/lala.txt', 'absolute to UNC #1')
call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/testdata/001/dev/sub/lala.txt'), '//stagesrv001.local/subaccess/lala.txt', 'absolute to UNC #2')

let g:IngoLibrary_ConfirmChoices = [ingo#fs#path#Normalize('//dropbox.com/asdf/mappedFile.txt'),  'http://www.dropbox.com/asdf/mappedFile.txt']
call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/testdata/001/file.txt'), '//dropbox.com/asdf/mappedFile.txt', 'absolute to UNC')
call vimtap#file#Is(FilePathConvert#ToGlobal(g:testdir . '/testdata/001/file.txt'), 'http://www.dropbox.com/asdf/mappedFile.txt', 'absolute to http')

let g:IngoLibrary_ConfirmChoices = [0]
call vimtap#err#Throws('Aborted', "call FilePathConvert#ToGlobal(g:testdir . '/testdata/001/file.txt')", 'user abort')

call vimtest#Quit()
