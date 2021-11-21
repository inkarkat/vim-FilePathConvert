" Test converting to global paths.

let g:FilePathConvert_UrlMappings = {}
edit testdata/001/dev/dev001.txt

call vimtest#StartTap()
call vimtap#Plan(9)

call vimtap#file#Is(FilePathConvert#ToGlobal('dev001.txt'), g:testdir . '/testdata/001/dev/dev001.txt', './dev001.txt')
call vimtap#file#Is(FilePathConvert#ToGlobal('sub/lala.txt'), g:testdir . '/testdata/001/dev/sub/lala.txt', './sub/lala.txt')
call vimtap#file#Is(FilePathConvert#ToGlobal('../file.txt'), g:testdir . '/testdata/001/file.txt', '../file.txt')
call vimtap#file#Is(FilePathConvert#ToGlobal('../prod/prod001.txt'), g:testdir . '/testdata/001/prod/prod001.txt', '../prod/prod001.txt')
call vimtap#file#Is(FilePathConvert#ToGlobal('../../foobar.txt'), g:testdir . '/testdata/foobar.txt', '../../foobar.txt')

call vimtap#err#ThrowsLike('^No URL mapping defined for filespec .*/testdata/001/dev/dev001.txt', 'call FilePathConvert#ToGlobal(g:testdir . ''/testdata/001/dev/dev001.txt'')', 'unmapped UNC path')

call vimtap#file#Is(FilePathConvert#ToGlobal('//testhost/testshare/testdata/foobar.txt'), 'file://///testhost/testshare/testdata/foobar.txt', 'fallback to file URL for UNC')

call vimtap#file#Is(FilePathConvert#ToGlobal('file://///testhost/testshare/testdata/foobar.txt'), '//testhost/testshare/testdata/foobar.txt', 'bounce of file URL to UNC')

call vimtap#err#Throws('No URL mapping defined for URL http://testhost/testshare/testdata/foobar.txt', 'call FilePathConvert#ToGlobal(''http://testhost/testshare/testdata/foobar.txt'')', 'unmapped http URL')

call vimtest#Quit()
