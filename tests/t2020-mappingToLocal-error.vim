" Test error on converting unmapped URLs to absolute paths.

edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(2)

call vimtap#err#Throws('No URL mapping defined for UNC path //stagesrv001.local/subaccessiores/expensive.txt', "call FilePathConvert#ToLocal('//stagesrv001.local/subaccessiores/expensive.txt')", 'unmapped longer UNC URL')
call vimtap#err#Throws('No URL mapping defined for UNC path //stagesrv001.local/sub/access.txt', "call FilePathConvert#ToLocal('//stagesrv001.local/sub/access.txt')", 'unmapped shorter UNC URL')

call vimtest#Quit()
