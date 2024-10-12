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
		\|| c ==# '?'
		\|| c ==# '*'
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
		elseif source =~# '^https://youtube.com/playlist'
			let TMPFILE=trim(system(["mktemp", "-u"]))
			call system('yt-dlp --flat-playlist --print id '.music_player#repr(source).' > '.TMPFILE)
			let video_ids = readfile(TMPFILE)
			call system('yt-dlp --flat-playlist --print title '.music_player#repr(source).' > '.TMPFILE)
			let video_names = readfile(TMPFILE)
			call delete(TMPFILE)
			let videos = len(video_ids)
			let video_number = 0
			while video_number <# videos
				let result += [['https://youtube.com/watch?v='..video_ids[video_number], video_names[video_number]]]
				let video_number += 1
			endwhile
		else
			if source =~# '^https://'
				let result += [[source, system('yt-dlp --flat-playlist --print title '.source)]]
				continue
			endif
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
				let result += [full_source, fnamemodify(full_source, ':t')]
			endif
		endif
	endfor
	return result
endfunction

function! music_player#handle_player_output(output, source, idx)
	if a:output ==# [""]
		if v:true
		\&& win_getid() ==# g:music_player_window_winid
		\&& bufnr() ==# g:music_player_window_bufnr
			execute a:idx + 1
		endif
		let g:music_player_job = music_player#play(a:source, a:idx)
	endif
endfunction

function! music_player#play(source, idx)
	let actual_source = music_player#repr(a:source)
	let g:music_player_track_idx = a:idx
	if a:idx <# len(g:music) - 1
		let next_music = a:idx + 1
	else
		let next_music = 0
	endif
	execute "
	\return jobstart(
	\	'yt-dlp '.actual_source.' -x --throttled-rate=100K -R 10000000000 --socket-timeout=5 -o - | mpv -',
	\	{
	\	'pty': v:true,
	\		'on_stdout':
	\		{j,d,e ->
	\			music_player#handle_player_output(
	\				d,
	\				g:music[".next_music."][0],
	\				".next_music."
	\			)
	\		}
	\	}
	\)"
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
	let g:music_player_window_bufnr = bufnr()
	enew
	file music player window
	setlocal filetype=musicplayer
	setlocal stc=
	setlocal nonu nornu
	setlocal buftype=nofile
	setlocal hidden
	setlocal nowrap
	setlocal nolinebreak
	setlocal list
	if a:sources ==# []
		call setline(1, 'Please select music to play')
		let music = []
	else
		let music = music_player#expand_sources(a:sources)
	endif
	for idx in range(len(music))
		let name = music[idx][1]
		call setline(idx + 1, name)
	endfor
	let g:music = music
	if len(music) ># 0
		let g:music_player_job = music_player#play(music[0][0], 0)
	endif
	setlocal nomodified
	setlocal nomodifiable
	nnoremap <buffer> p <cmd>call music_player#pause()<cr>
endfunction

function! music_player#switch_track(idx)
	if exists('g:music_player_job')
		if a:idx !=# g:music_player_track_idx
			call jobstop(g:music_player_job)
			let g:music_player_job = music_player#play(g:music[a:idx][0], a:idx)
		endif
	endif
endfunction
