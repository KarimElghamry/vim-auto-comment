# vim-auto-comment
A simple vim plugin for auto commenting/uncommenting multiple lines depending on the given file. 

<p align="center"><img src="https://media.giphy.com/media/3pIkKvNkV6gLkEbCt5/giphy.gif"></p>

## Install
A plugin manager is recommended to easily install this plugin.

for `vim-plug` users, add the following to your `.vimrc` (`init.vim` for nvim) file:

```Vim script
Plug 'KarimElghamry/vim-auto-comment'
```
source the file then run the `:PlugInstall` command.

## Usage
there are two main settings that you can change in this plugin: `inline` and `block` comments.

### Inline
- To change the default inline comment token, set the following global variable:

```Vim script
let g:default_inline_comment = '<your desired token here>'
```

the default token is set to:

```Vim script
let g:default_inline_comment = '#'
```

- To change the inline comment token for a specific file, you can add your entry to the following dictionary:

```Vim script
let g:inline_comment_dict = {}
```
the `key` is the comment token and the `value` is a list of file extensions.

the default `g:inline_comment_dict` is set to:

```Vim script
let g:inline_comment_dict = {
		\'//': ["js", "ts", "cpp", "c", "dart"],
		\'#': ['py', 'sh'],
		\'"': ['vim'],
		\}

```

### Block
- To change the default block comment token, set the following global variable:

```Vim script
let g:default_block_comment = '<your desired token here>'
```

the default token is set to:

```Vim script
let g:default_block_comment = '/*'
```

- To change the block comment token for a specific file, you can add your entry to the following dictionary:

```Vim script
let g:block_comment_dict = {}
```
the `key` is the comment token and the `value` is a list of file extensions.

the default `g:block_comment_dict` is set to:

```Vim script
let g:block_comment_dict = {
		\'/*': ["js", "ts", "cpp", "c", "dart"],
		\'"""': ['py'],
		\}

```

## Commands
`:AutoInlineComment`: comments\uncomments the line under the cursor position using the defined **inline** comment token in `Normal` mode, and does the same for the selected lines in the `Visual` mode.

`:AutoBlockComment`: comments\uncomments the line under the cursor position using the defined **block** comment token in `Normal` mode, and does the same for the selected lines in the `Visual` mode.


## Mapping
The default mapping is done for the `Normal` and `Visual` modes.

- to trigger `:AutoInlineComment` in both modes, press <kbd>Ctrl</kbd> + <kbd>/</kbd>.

- to trigger `:AutoBlockComment` in both modes, press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd>.

- to **opt out** from the default mappings, set the following global variable to `0`:

```Vim Script
let g:autocomment_map_keys = 0
```
and set your desired mappings as you wish. for example:

```Vim Script

" Inline comment mapping
vnoremap <silent><C-_> :AutoInlineComment<CR>
nnoremap <silent><C-_> :AutoInlineComment<CR>

" Block comment mapping
vnoremap <silent><C-S-a> :AutoBlockComment<CR>
nnoremap <silent><C-S-a> :AutoBlockComment<CR>
```
