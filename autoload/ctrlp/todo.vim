if ( exists('g:loaded_ctrlp_todo') && g:loaded_ctrlp_todo )
            \ || v:version < 700 || &cp
    finish
endif

let g:loaded_ctrlp_todo = 1

let s:todo_var = {
            \ 'init': 'ctrlp#todo#init(s:crbufnr)',
            \ 'accept': 'ctrlp#todo#accept',
            \ 'lname': 'todo',
            \ 'sname': 'todo',
            \ 'type': 'line',
            \ 'sort': 0,
            \ }

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
    let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:todo_var)
else
    let g:ctrlp_ext_vars = [s:todo_var]
endif

function! ctrlp#todo#init(bufnr)
    let entries = []
    let lines = split(system('git grep -n -e TODO -e FIXME -e XXX | cat'), '\n')
    if v:shell_error != 0 | continue | endif
    let formatter = [':\s\+', ': ', 'g']
    let [pat, str, flags] = [get(formatter, 0, ''), get(formatter, 1, ''), get(formatter, 2, '')]
    syn match Comment /\/\/.*$/
    syn match Directory /\w.*\.\w\+/
    syn match Folded /\d\+/
    for line in lines
        "call add(entries, line)
        call add(entries, substitute(line, pat, str, flags))
    endfor
    return entries
endfunction

func! ctrlp#todo#accept(mode, str)
    call ctrlp#exit()
    let info = matchlist(a:str, '^\([^:]*\):\([^:]*\):\(.*\)')
    call ctrlp#acceptfile(a:mode, get(info, 1))
    call cursor(get(info, 2), 1)
    normal! ^
endfunc

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
func! ctrlp#todo#id()
    return s:id
endfun
