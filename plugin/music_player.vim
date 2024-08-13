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

function! music_player#track_switching_cursor_moved_handler()
	if !exists('g:music_player_job')
		return
	endif
	if win_getid() ==# g:music_player_window_winid
		call music_player#switch_track(line('.')-1)
	endif
endfunction

function! music_player#track_switching_buffer_changed_handler()
	if !exists('g:music_player_job')
		return
	endif
	if win_getid() ==# g:music_player_window_winid
		execute g:music_player_track_idx + 1
	endif
endfunction

augroup music_player_track_switching
	autocmd!
	autocmd CursorMoved * call music_player#track_switching_cursor_moved_handler()
	autocmd BufEnter * call music_player#track_switching_buffer_changed_handler()
augroup END
