"============================================================================
"
"File:        vim-auto-comment.vim
"Author:      Karim Elghamry <karimelghamry@gmail.com> 
"Version:     1.0.0 
"Description: Vim plugin for auto commenting/uncommenting multiple lines
" 	      depending on the given file 
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================
"
" ---------------------------------- "
" dictionary for mapping inline comment tokens to the corresponding files
let g:inline_comment_dict = get(g:, 'inline_comment_dict', 
	        \{
		\'//': ["js", "ts", "cpp", "c", "dart", "go"],
		\'#': ['py', 'sh'],
		\'"': ['vim'],
		\})

" variable for setting the default inlink comment token if the current file is
" not found in the dictionary
let g:default_inline_comment = get(g:, 'default_inline_comment', '#')


" dictionary for mapping block comment tokens to the corresponding files
let g:block_comment_dict = get(g:, 'block_comment_dict', {
		\'/*': ["js", "ts", "cpp", "c", "dart"],
		\'"""': ['py'],
		\})


" variable for setting the default inlink comment token if the current file is
" not found in the dictionary
let g:default_block_comment = get(g:, 'default_block_comment', '/*')

" ---------------------------------- "
" function to reverse a given string
function! s:ReverseString(input_string)
    let output = ''
    for i in split(a:input_string, '\zs')
	let output = i . output
    endfor
    return output
endfunction

" ---------------------------------- "
"   function for inline auto commenting
function! s:AutoInlineComment()
"   get extension    
    let extension = expand('%:e')
    let comment = g:default_inline_comment 

"   check file extension against each entry in inline comment dictionary    
    for item in items(g:inline_comment_dict) 
	if index(item[1], extension) >= 0
	    let comment = item[0]
	    break
	endif
    endfor
 
"   trim leading white spaces
    let current_line = substitute(getline("."), '^[ ]*', '' , 'g')

"   check if current line is commented or not
    if(current_line[:len(comment) - 1] != comment)
	execute ':s/^/' . escape(comment, '^$.*?/\[]') . ' /' 
    else
	execute ':s/^\( *\)' . escape(comment, '^$.*?/\[]') . '\( \?\)//' 
    endif

    :noh
endfunction


" ---------------------------------- "
"   function for block auto commenting
function! s:AutoBlockComment() range
"   get extension    
    let extension = expand('%:e')
    let comment = g:default_block_comment 

"   check file extension against each entry in block comment dictionary    
    for item in items(g:block_comment_dict) 
	if index(item[1], extension) >= 0
	    let comment = item[0]
	    break
	endif
    endfor
"   reverse the comment token
    let reverse_comment = s:ReverseString(comment)

"   get first and last tokens
    let firstline_token = substitute(getline(a:firstline), '^[ ]*', '', 'g')[:len(comment) - 1] 
    let lastline_token = substitute(getline(a:lastline), '[ ]*$', '', 'g')[-len(comment):]

"   check if the block is commented and parse accordingly
    if (firstline_token == comment && lastline_token == reverse_comment)
	execute ':'. a:firstline . ',' . a:firstline . 's/^\( *\)' . escape(comment, '^$.*?/\[]') . '\( \?\)//'
	execute ':'. a:lastline . ',' . a:lastline . 's/\s\?' . escape(reverse_comment, '^$.*?/\[]') . '$//'
    else
	execute ':'. a:firstline . ',' . a:firstline . 's/^/' . escape(comment, '^$.*?/\[]') . ' /'
	execute ':'. a:lastline . ',' . a:lastline . 's/$/ ' . escape(reverse_comment, '^$.*?/\[]') . '/'
    endif
endfunction


" ---------------------------------- "
"  define commands
command! -range AutoInlineComment <line1>,<line2>call <sid>AutoInlineComment()
command! -range AutoBlockComment <line1>,<line2>call <sid>AutoBlockComment() 

" ---------------------------------- "
"  define default mappings
if !exists('g:autocomment_map_keys')
    let g:autocomment_map_keys = 1
endif

if (g:autocomment_map_keys)
    vnoremap <silent><C-_> :AutoInlineComment<CR>
    nnoremap <silent><C-_> :AutoInlineComment<CR>
	
    vnoremap <silent><C-S-a> :AutoBlockComment<CR>
    nnoremap <silent><C-S-a> :AutoBlockComment<CR>
endif

