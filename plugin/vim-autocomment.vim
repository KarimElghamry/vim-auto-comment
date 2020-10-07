let g:inline_comment_dict = {'//': ["js", "jsx", "ts", "tsx", "cpp", "c", "dart"],
		\'#': ['py', 'sh'],
		\'"': ['vim'],
		\}

let g:default_inline_comment = '#'


let g:block_comment_dict = {'/*': ["js", "jsx", "ts", "tsx", "cpp", "c", "dart"],
		\'"""': ['py'],
		\}

let g:default_block_comment = '/*'

" function to reverse a given string
function! s:ReverseString(input_string)
    let output = ''
    for i in split(a:input_string, '\zs')
	let output = i . output
    endfor
    return output
endfunction

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


function! s:AutoBlockComment() range
"   get extension    
    let extension = expand('%:e')
    let comment = g:default_block_comment 

"   check file extension against each entry in inline comment dictionary    
    for item in items(g:block_comment_dict) 
	if index(item[1], extension) >= 0
	    let comment = item[0]
	    break
	endif
    endfor

    let reverse_comment = s:ReverseString(comment)
    let firstline_character = substitute(getline(a:firstline), '^[ ]*', '', 'g')[:len(comment) - 1] 
    let lastline_character = substitute(getline(a:lastline), '[ ]*$', '', 'g')[-len(comment):]

    if (firstline_character == comment && lastline_character == reverse_comment)
	execute ':'. a:firstline . ',' . a:firstline . 's/^\( *\)' . escape(comment, '^$.*?/\[]') . '\( \?\)//'
	execute ':'. a:lastline . ',' . a:lastline . 's/\s\?' . escape(reverse_comment, '^$.*?/\[]') . '$//'
    else
	execute ':'. a:firstline . ',' . a:firstline . 's/^/' . escape(comment, '^$.*?/\[]') . ' /'
	execute ':'. a:lastline . ',' . a:lastline . 's/$/ ' . escape(reverse_comment, '^$.*?/\[]') . '/'
    endif
endfunction

command! -range AutoInlineComment <line1>,<line2>call <sid>AutoInlineComment()
command! -range AutoBlockComment <line1>,<line2>call <sid>AutoBlockComment() 

if !exists('g:autocomment_map_keys')
    let g:autocomment_map_keys = 1
endif

if (g:autocomment_map_keys)
    vnoremap <silent><C-_> :AutoInlineComment<CR>
    nnoremap <silent><C-_> :AutoInlineComment<CR>
	
    vnoremap <silent><C-S-a> :AutoBlockComment<CR>
    nnoremap <silent><C-S-a> :AutoBlockComment<CR>
endif

