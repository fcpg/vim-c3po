" c3po.vim - ColorColumn Current POsition
" Author: fcpg
" Credits: @drzel vim-line-no-indicator

if exists("g:loaded_c3po") || &cp
  finish
endif
let g:loaded_c3po = 1

let s:save_cpo = &cpo
set cpo&vim

"---------------
" Settings {{{1
"---------------

let s:c3po_min = get(g:, 'c3po_min', 1)
let s:c3po_max = get(g:, 'c3po_max', 80)
let s:c3po_width = s:c3po_max - s:c3po_min


"----------------
" Functions {{{1
"----------------

function! GetC3POColumn()
  let curline  = line(".") - 1
  let lastline = line("$") - 1

  if curline == 0
    let col = s:c3po_min
  elseif curline == lastline
    let col = s:c3po_max
  else
    let pct = floor(curline) / floor(lastline)
    let col = 1+float2nr(round(pct * (s:c3po_width-1)))
  endif

  return col
endfun


"---------------
" Autocmds {{{1
"---------------

augroup C3PO
  au!
  autocmd CursorMoved *
        \  let &cc = get(g:, 'cc', '')
        \| let &cc .= (&cc != ''?',':'').GetC3POColumn()
augroup END

let &cpo = s:save_cpo

" vim: et sw=2:
