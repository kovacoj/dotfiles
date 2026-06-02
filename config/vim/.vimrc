set number
set relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Keep the visual selection active while indenting.
vnoremap > >gv
vnoremap < <gv
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

function! CopyVisualToClipboardOSC52() abort
  let l:save_reg = getreg('"')
  let l:save_type = getregtype('"')

  silent normal! gv""y
  let l:text = getreg('"')

  call setreg('"', l:save_reg, l:save_type)

  if empty(l:text)
    return
  endif

  let l:encoded = system('base64 -w0', l:text)
  if v:shell_error != 0
    echoerr 'base64 encoding failed'
    return
  endif

  let l:encoded = substitute(l:encoded, '\n\+$', '', '')
  let l:osc = "\e]52;c;" . l:encoded . "\x07"

  if exists('$TMUX') && !empty($TMUX)
    let l:osc = "\ePtmux;\e" . l:osc . "\e\\"
  endif

  call writefile([l:osc], '/dev/tty', 'b')
  echo 'Copied selection to clipboard'
endfunction

xnoremap <silent> <Space>y :<C-u>call CopyVisualToClipboardOSC52()<CR>
