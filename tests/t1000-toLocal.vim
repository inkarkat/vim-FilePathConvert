" Test converting to local paths.

let g:FilePathConvert_UrlMappings = {}
edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(10)

call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/testdata/001/dev/dev001.txt'), 'dev001.txt', './dev001.txt')
call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/testdata/001/dev/sub/lala.txt'), 'sub/lala.txt', './sub/lala.txt')
call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/testdata/001/file.txt'), '../file.txt', '../file.txt')
call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/testdata/001/prod/prod001.txt'), '../prod/prod001.txt', '../prod/prod001.txt')
call vimtap#file#Is(FilePathConvert#ToLocal(g:testdir . '/testdata/foobar.txt'), '../../foobar.txt', '../../foobar.txt')

call vimtap#file#Is(FilePathConvert#ToLocal('dev001.txt'), g:testdir . '/testdata/001/dev/dev001.txt', 'bounce of relative dev001.txt to absolute')
call vimtap#file#Is(FilePathConvert#ToLocal('../prod/prod001.txt'), g:testdir . '/testdata/001/prod/prod001.txt', 'bounce of relative ../prod/prod001.txt to absolute')

call vimtap#err#Throws('No URL mapping defined for UNC path \\testhost\testshare\testdata\foobar.txt', 'call FilePathConvert#ToLocal(''\\testhost\testshare\testdata\foobar.txt'')', 'unmapped UNC path')
call vimtap#err#Throws('No URL mapping defined for URL http://testhost/testshare/testdata/foobar.txt', 'call FilePathConvert#ToLocal("http://testhost/testshare/testdata/foobar.txt")', 'unmapped URL')
echomsg 'Test: fallback warning'
call vimtap#file#Is(FilePathConvert#ToLocal('file://///testhost/testshare/testdata/foobar.txt'), '//testhost/testshare/testdata/foobar.txt', 'fallback to UNC for file URL')

call vimtest#Quit()
