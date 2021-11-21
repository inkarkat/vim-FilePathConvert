" Test converting with differing case to global paths.

call vimtest#SkipAndQuitIf(! ingo#fs#path#IsCaseInsensitive(g:testdir), 'Need case-insensitive file system')

let g:FilePathConvert_UrlMappings = {}
edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(3)

call vimtap#file#Is(FilePathConvert#ToGlobal('../PROD/prod001.txt'), g:testdir . '/testdata/001/PROD/prod001.txt', '../PROD/prod001.txt, case difference in path')
call vimtap#file#Is(FilePathConvert#ToGlobal('../prod/PROD001.TXT'), g:testdir . '/testdata/001/prod/PROD001.TXT', '../prod/PROD001.TXT, case difference in filename')
call vimtap#file#Is(FilePathConvert#ToGlobal('../PROD/PROD001.TXT'), g:testdir . '/testdata/001/PROD/PROD001.TXT', '../PROD/PROD001.TXT, case difference in both')

call vimtest#Quit()
