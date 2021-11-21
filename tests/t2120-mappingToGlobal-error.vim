" Test error on converting absolute paths to mapped URLs.

edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(2)

call vimtap#err#Throws('No URL mapping defined for filespec ' . g:testdir . '/testdata/001/devileyed/lala.txt', "call FilePathConvert#ToGlobal(g:testdir . '/testdata/001/devileyed/lala.txt')", 'unmapped longer absolute filespec')
call vimtap#err#Throws('No URL mapping defined for filespec ' . g:testdir . '/testdata/001/de/vi.txt', "call FilePathConvert#ToGlobal(g:testdir . '/testdata/001/de/vi.txt')", 'unmapped shorter absolute filespec')

call vimtest#Quit()
