## install

```bash
cd ~
git clone git@github.com:phanen/dotfiles.git --depth=1
cd dotfiles
make
```

> - all installed packages can be found in [.config/pkglists/](.config/pkglists/)
> - here are aur packages I maintain: <https://aur.archlinux.org/packages?SeB=M&K=phanium>

## basic softwares
> a WIP best practice for a nerd like me

the softwares I am using (maybe helpful for xorg boomers...)
- window manage: bspwm, bsp-layout, tabbed, bsptab
    - to use bspwm is just a coincidence for me, it's no double more useful than dwm for me (c/s model, hot update)
    - weakness: too minimal, need to patch a lot (for features like stack-based layout and "tabbed")
- display manage: .xinitrc is all I need
- launch/keymap: polybar, rofi, kmonad, sxhkbd
    - rofi and polybar are both a compromise
    - TODO
- terminal/shell: alacritty, fish, zsh
    - it turns out that vi-mode is the only reason I use alacritty, since I don't care about 0.001s faster than kitty
    - fish has a stronger default, zsh is like a boomer (ok, just a joke)
    - but that's still no much ones write fish scripts
- browse/pdf: chromium (vimium-c, pdf.js)
    - the weakness pdf.js causes a little blur and slow
    - but zathura/sioyak isn't more useful than browser for me
- editor: neovim (a.k.a. god of editor)
- file manage: neovim, fish-fifc
    - picker + previewer, that's enough for file manage
    - "professonal" manager like vifm, joshuto is not actually most used
- font: CaskaydiaCove Nerd Font, FiraCode Nerd Font
- dotfiles manage: git repo for roll back
    - for quick modificatoin of config? that's job of neovim...

## tips and tricks

basically some guides on living in terminal or get ride of mouse
- neovim is useful as manpager, but not common pager
    - less is still the best pager for most cases
    - you means bat? I think that's a previewer...
- fzf anywhere, e.g. fish-fifc, sysz, fontpreview-ueberzug, telescope
- blazing fast manual look-up: tealdeer
- chores app: xclip, slock, dunst, flameshot, ffmpeg, cronie, sxiv, gimp, mpv
    - if possible, keybind most used operations/apps though kmonad/sxhkd

> by the way, any advice on how to stop the world to use format like `.docx`, `.docx` `.ppt` `.pptx` ...

## neovim

```tree
.
├── after
│   └── ftplugin
│       ├── help.lua
│       └── markdown.lua
├── filetype.lua
├── init.lua
├── lazy-lock.json
├── lua
│   ├── mappings.lua
│   ├── options.lua
│   ├── plugins
│   │   ├── buffer.lua
│   │   ├── cmp.lua
│   │   ├── dap.lua
│   │   ├── doc.lua
│   │   ├── edit.lua
│   │   ├── explore.lua
│   │   ├── git.lua
│   │   ├── hydra.lua
│   │   ├── init.lua
│   │   ├── lsp.lua
│   │   ├── misc.lua
│   │   ├── move.lua
│   │   ├── qf.lua
│   │   ├── session.lua
│   │   ├── snip.lua
│   │   ├── syntax.lua
│   │   ├── telescope.lua
│   │   ├── terminal.lua
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
│   ├── commands.vim
│   ├── jumplist.vim
│   ├── quickfix.lua
│   └── textobjects.lua
├── snippets
│   ├── json.json
│   └── package.json
├── spell
│   └── en.utf-8.add
└── theme
```
