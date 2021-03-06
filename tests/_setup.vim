call vimtest#AddDependency('vim-ingo-library')

runtime plugin/FilePathConvert.vim
let g:testdir = expand('<sfile>:p:h')
let g:outsideDir = expand('<sfile>:p:h:h:h:h:h:h:h:h:h:h:h:h:h:h:h:h:h:h:h:h') . 'var/server/subgroup'
let g:FilePathConvert_UrlMappings = {
\   'http://testwebserver.org/instance': g:testdir . '/testdata/001/prod',
\   '//stagesrv001.local/stage': g:testdir . '/testdata/001/dev',
\   '//stagesrv001.local/subaccess': [g:testdir . '/testdata/001/dev/sub', g:outsideDir],
\   '//dropbox.com/asdf/mappedFile.txt': g:testdir . '/testdata/001/file.txt',
\   'http://www.dropbox.com/asdf/mappedFile.txt': g:testdir . '/testdata/001/file.txt',
\}
