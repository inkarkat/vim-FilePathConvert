" Test converting with differing case to local paths.

call vimtest#SkipAndQuitIf(! ingo#fs#path#IsCaseInsensitive(g:testdir), 'Need case-insensitive file system')

let g:FilePathConvert_UrlMappings = {}
edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(4)

call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/TESTDATA/001/prod/prod001.txt'), '../prod/prod001.txt', '../prod/prod001.txt, case difference in path')
call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/testdata/001/prod/PROD001.TXT'), '../prod/PROD001.TXT', '../prod/PROD001.TXT, case difference in filename')
call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/TESTDATA/001/prod/PROD001.TXT'), '../prod/PROD001.TXT', '../prod/PROD001.TXT, case difference in both')
call vimtap#file#Is(FilePathConvert#ToLocal(toupper(g:testdir) . '/TESTDATA/001/PROD/PROD001.TXT'), '../PROD/PROD001.TXT', '../PROD/PROD001.TXT, case difference in all')

call vimtest#Quit()
