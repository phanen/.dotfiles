## install

```bash
cd ~
git clone git@github.com:phanen/dotfiles.git --depth=1
cd dotfiles
make
```

> packages can be found in [.config/.pkglists/](.config/.pkglists/)

## basic info

| program                | name                      |
| ---------------------- | ------------------------- |
| window manager         | bspwm, dwm                |
| application launcher   | rofi                      |
| fonts                  | FiraCode Nerd Font        |
| terminal emulator      | alacritty,kitty,st        |
| terminal multiplexer   | tabbed, tmux              |
| shell                  | fish, zsh, bash           |
| key remapper           | kmonad, sxhkbd            |
| text editor            | neovim                    |
| bar                    | polybar                   |
| display manager        | none(`.xinitrc`)          |
| input method framework | fcitx5                    |
| file manager           | vifm, joshuto             |
| music player           | musicfox                  |
| media player           | mpv                       |
| image viewer           | sxiv, feh                 |
| image editor           | gimp                      |
| lockscreen             | slock                     |
| notification daemon    | dunst                     |
| screenshot software    | flameshot                 |
| screen recording       | ffmpeg                    |
| clipboard              | xclip xsel                |
| pdf reader             | chromium, zathura, sioyek |
| pdf editor             | pdfarranger, pdf-crop     |
| manual                 | tealdeer                  |
| task runner            | cronie                    |

## nvim

```
.config/nvim
├── after
│   └── ftplugin
│       ├── help.lua
│       └── markdown.lua
├── filetype.lua
├── init.lua
├── lazy-lock.json
├── lua
│   ├── library
│   │   └── init.lua
│   ├── mappings.lua
│   ├── options.lua
│   ├── plugins
│   │   ├── autosave.lua
│   │   ├── cmp.lua
│   │   ├── dap.lua
│   │   ├── doc.lua
│   │   ├── draw.lua
│   │   ├── edit.lua
│   │   ├── explore.lua
│   │   ├── git.lua
│   │   ├── hydra.lua
│   │   ├── init.lua
│   │   ├── lsp.lua
│   │   ├── misc.lua
│   │   ├── move.lua
│   │   ├── nav.lua
│   │   ├── outline.lua
│   │   ├── qf.lua
│   │   ├── session.lua
│   │   ├── snip.lua
│   │   ├── syntax.lua
│   │   ├── telescope.lua
│   │   ├── term.lua
│   │   ├── theme.lua
│   │   ├── treesitter.lua
│   │   ├── ui.lua
│   │   └── util.lua
│   └── utils
│       ├── init.lua
│       ├── keymap.lua
│       └── lsp.lua
├── luasnippets
│   ├── all.lua
│   ├── gitcommit.lua
│   ├── markdown.lua
│   └── rust.lua
├── plugin
│   ├── autocommands.lua
│   ├── commands.lua
│   ├── quickfix.lua
│   └── textobjects.lua
├── snippets
│   ├── json.json
│   └── package.json
├── spell
│   └── en.utf-8.add
└── theme
```
