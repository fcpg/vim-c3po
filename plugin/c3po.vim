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

" GetC3POColumn {{{2
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

" ToggleC3PO {{{2
" Args:  true to turn off all cc when toggling off
function! ToggleC3PO(...)
  let all = a:0 ? a:1 : 0
  redir => aulist
  silent! autocmd C3PO
  redir END
  let aulist = substitute(aulist, '\n[^\n]*', '', '')
  if !len(aulist)
    call <Sid>SetAutocmds()
    call <Sid>SetCC()
  else
    au! C3PO
    let &cc = all ? '' : get(g:, 'cc', '')
    let g:c3po_on = 0
  endif
endfun

" s:SetCC {{{2
function! s:SetCC()
  let &cc = get(g:, 'cc', '')
  let &cc .= (&cc != ''?',':'').GetC3POColumn()
endfun

" s:SetAutocmds {{{2
function! s:SetAutocmds()
  augroup C3PO
    au!
    autocmd CursorMoved *  call <Sid>SetCC()
  augroup END
  let g:c3po_on = 1
endfun


"-----------
" Init {{{1
"-----------

com! -bang ToggleC3PO
      \ call ToggleC3PO()

call <Sid>SetAutocmds()

let &cpo = s:save_cpo

" vim: et sw=2:
