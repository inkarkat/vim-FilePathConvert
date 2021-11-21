" Test converting mapped URLs to absolute paths via buffer-local config.

edit testdata/001/dev/dev001.txt
let b:FilePathConvert_UrlMappings = {'http://127.0.0.1': g:testdir . '/testdata/002'}
let b:basedir = g:testdir . '/testdata/003'
let b:baseurl = 'http://localhost:8080'

call vimtest#StartTap()
call vimtap#Plan(3)

call vimtap#file#Is(FilePathConvert#ToLocal('http://127.0.0.1/instance002.txt'), g:testdir . '/testdata/002/instance002.txt', 'http to absolute from buffer-local')
call vimtap#file#Is(FilePathConvert#ToLocal(b:baseurl . '/instance003.txt'), g:testdir . '/testdata/003/instance003.txt', 'http to absolute from b:baseurl')

call vimtap#err#Throws('No URL mapping defined for URL http://testwebserver.org/instance/prod001.txt', "call FilePathConvert#ToLocal('http://testwebserver.org/instance/prod001.txt')", 'global mapping ignored')

call vimtest#Quit()
