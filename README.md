Simple music player written in Vimscript

# Installation

Using [lazy.vim](https://github.com/folke/lazy.nvim):
```lua
{
  "TwoSpikes/music-player.vim",
}
```

Using [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'TwoSpikes/music-player.vim'
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):
```lua
use 'TwoSpikes/music-player.vim'
```

Using [pckr.nvim](https://github.com/lewis6991/pckr.nvim):
```lua
'TwoSpikes/music-player.vim'
```

Using [dein](https://github.com/Shougo/dein.vim):
```vim
call dein#add('TwoSpikes/music-player.vim')
```

Using [paq-nvim](https://github.com/savq/paq-nvim):
```lua
'TwoSpikes/music-player.vim'
```

Using [Pathogen](https://github.com/tpope/vim-pathogen):
```console
$ cd ~/.vim/bundle && git clone https://github.com/TwoSpikes/music-player.vim
```

Using Vim built-in package manager (requires Vim v.8.0+) ([help](https://vimhelp.org/repeat.txt.html#packages) or `:h packages`):
```console
$ cd ~/.vim/pack/test/start/ && git clone https://github.com/TwoSpikes/music-player.vim
```

# Usage

```vim
:call music_player#open_window('directory/with/music')
```

It can read files in directory and recursively read directories

It supports links to YouTube videos and playlists. (It will unpack a playlist and add videos in it to queue)

Press `p` to pause/unpause.

Press `j`, `k` to switch track, or select it with mouse.

# Dependencies

[mpv](https://github.com/mpv-player/mpv)
