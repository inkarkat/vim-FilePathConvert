FILE PATH CONVERT
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This plugin converts a file path and name that is inserted into the buffer
between absolute and relative paths. This is especially useful after pasting
in or completing (i\_CTRL-X\_CTRL-F) filespecs.

### RELATED WORKS

- html\_FileCompletion.vim ([vimscript #4070](http://www.vim.org/scripts/script.php?script_id=4070)) is insert mode completion of
  URL-escaped file links relative to a document root and base URL.

USAGE
------------------------------------------------------------------------------

    <Leader>sf              Convert the file whose name is under or after the
                            cursor to a more local one:
                            URL -> [ UNC -> ] absolute -> relative (-> absolute)
    {Visual}<Leader>sf      Convert the selected file name.

    <Leader>sF              Convert the file whose name is under or after the
                            cursor to a more global one:
                            relative -> absolute  -> [ UNC -> ] URL (-> UNC / abs)
    {Visual}<Leader>sF      Convert the selected file name.

                            A relative file path (../foo) is converted to an
                            absolute one (/home/user/dir/foo).
                            An absolute file path (/home/user/dir/foo) is
                            converted to a relative one (../foo).
                            On Windows, an absolute filespec starts with a drive
                            letter (C:\foo).
                            A URL starts with a protocol like file://; the actual
                            protocol is ignored here. Or it is a Windows file
                            share in UNC notation (\\host\share\foo).
                            Unless a mapping of URL prefix to mount point exists
                            (see g:FilePathConvert_UrlMappings), this can only
                            be mapped to a generic share in UNC notation.

### EXAMPLE

Here's a simple illustration:

    :cd C:\Windows\Temp
    :edit test.txt

The text
```
    C:\Windows\System32\drivers\etc\hosts
```
is turned into:
```
    ..\System32\drivers\etc\hosts
```
and
```
    Cookies\index.dat
```
is turned into:
```
    C:\Windows\Temp\Cookies\index.dat
```

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-FilePathConvert
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim FilePathConvert*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.035 or
  higher.
- Requires the TextTransform plugin ([vimscript #4005](http://www.vim.org/scripts/script.php?script_id=4005)), version 1.22 or higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

To be able to convert custom URLs, non-file:// protocols, and UNC paths to a
local file system path, you need to specify the mapping of the base URL to
mount point(s; you can configure a list of filespecs to cater for symbolic
links etc.):

    let g:FilePathConvert_UrlMappings = {
    \   '//win/share': 'D:/data',
    \   'file://///lin/www/htdocs': '/var/srv/htdocs',
    \   'http://lin/': '/var/srv/htdocs',
    \   'file://///srv/user': ['/var/srv/user', '/home/user']
    \}

As the filespecs are system-specific, you probably want to define them for the
current host; the hostname() function can help to write a conditional in
case you're using a .vimrc shared across multiple systems.
You can override the global mapping with a buffer-local one, too.

If you just want to add a single mapping for the current buffer, you can do
that by defining both b:baseurl and b:basedir variables.

If you want to use different mappings, map your keys to the
&lt;Plug&gt;TextTFilePathConvert#... mapping targets _before_ sourcing the script
(e.g. in your vimrc):

    nmap <Leader>sf <Plug>TextTFilePathConvert#FilePathConvertLine
    xmap <Leader>sf <Plug>TextTFilePathConvert#FilePathConvertVisual

TODO
------------------------------------------------------------------------------

- Add conversion to / from file:// URLs, with a configurable base dir and URL
  prefix.

### CONTRIBUTING

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-FilePathConvert/issues or email (address
below).

HISTORY
------------------------------------------------------------------------------

##### 2.01    RELEASEME
-

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.035!__

##### 2.00    31-May-2014
- Add &lt;Leader&gt;sF variant that converts into more global filespecs to support
  file:// URLs.
- Handle conversion to / from UNC and URL paths via URL mappings configuation
  g:FilePathConvert\_UrlMappings.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.019!__

##### 1.00    06-Mar-2014
- First published version.

##### 0.01    09-May-2012
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2012-2022 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
