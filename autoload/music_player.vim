" Copyright © 2024 John Doe. All rights reserved.
" Contacts: <twospikesfpg@gmail.com>
" 
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
" 
" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.
" 
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.

if exists('g:loaded_music_player')
	finish
endif
let g:loaded_music_player = 1

function! music_player#repr(text)
	let result = ""
	for c in a:text
		if v:false
		elseif v:false
		\|| c ==# ' '
		\|| c ==# ''''
		\|| c ==# '"'
		\|| c ==# '|'
		\|| c ==# '<'
		\|| c ==# '>'
		\|| c ==# '&'
		\|| c ==# '['
		\|| c ==# ']'
		\|| c ==# '('
		\|| c ==# ')'
		\|| c ==# '#'
			let result .= '\'.c
		else
			let result .= c
		endif
	endfor
	return result
endfunction

function! music_player#expand_sources(sources)
	let result = []
	for source in a:sources
		if source !~# '^https://' && isdirectory(expand(source))
			let result += music_player#expand_sources(map(readdir(expand(source)), {_, entry -> expand(source)..'/'..entry}))
		else
			let full_source = expand(source)
			if v:false
			elseif v:false
			\|| full_source =~# '\.m4a$'
			\|| full_source =~# '\.flac$'
			\|| full_source =~# '\.mp3$'
			\|| full_source =~# '\.mp4$'
			\|| full_source =~# '\.wav$'
			\|| full_source =~# '\.wma$'
			\|| full_source =~# '\.aac$'
				let result += [full_source]
			endif
		endif
	endfor
	return result
endfunction

function! music_player#handle_player_output(output, source, idx)
	if a:output ==# [""]
		let g:music_player_job = music_player#play(a:source, a:idx)
	endif
endfunction

function! music_player#play(source, idx)
	let escaped_source = music_player#repr(a:source)
	return jobstart('mpv '.escaped_source, {
	\	'pty': v:true,
	\	'on_stdout': {j,d,e ->
	\		music_player#handle_player_output(d, g:music[a:idx+1], a:idx+1)
	\	}
	\})
endfunction

function! music_player#pause()
	if exists('g:music_player_job')
		execute "lua vim.api.nvim_chan_send(".g:music_player_job.', "p")'
	else
		echohl ErrorMsg
		echomsg "Please select music to play"
		echohl Normal
	endif
endfunction

function! music_player#open_window(sources=[])
	vsplit
	let g:music_player_window_winid = win_getid()
	enew
	file music player window
	set filetype=musicplayer
	setlocal stc=
	setlocal nonu nornu
	setlocal buftype=nofile
	setlocal hidden
	if a:sources ==# []
		call setline(1, 'Please select music to play')
		let music = []
	else
		let music = music_player#expand_sources(a:sources)
	endif
	for idx in range(len(music))
		let track = music[idx]
		call setline(idx + 1, fnamemodify(track, ':t'))
	endfor
	if len(music) ># 0
		let g:music_player_job = music_player#play(music[0], 0)
	endif
	let g:music = music
	set nomodified
	set nomodifiable
	nnoremap <buffer> p <cmd>call music_player#pause()<cr>
endfunction

