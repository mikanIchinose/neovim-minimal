# neovim-minimal

Start develop your neovim

```bash
# pattern#1: using docker-compose
docker-compose up -d
docker-compose exec neovim bash

# pattern#2: using make
make start

$ cd .config/nvim
$ nvim
```

## container setting

```yml
# docker-compose.yml
VIM_ENABLE_NODE: '' # set 'y' to install latest node.js
VIM_ENABLE_PYTHON: '' # set 'y' to install python2
VIM_ENABLE_PYTHON3: '' # set 'y' to install python3
VIM_ENABLE_DEIN: 'y' # set 'y' to install dein.nvim
VIM_ENABLE_PACKER: '' # set 'y' to install packer.nvim
RIPGREP_VERSION: '' # set version to install ripgrep
FD_VERSION: '' # set version to insatall fd
BAT_VERSION: '' # set version to install bat
```

## additional tool

[ripgrep](https://github.com/BurntSushi/ripgrep)
[fd](https://github.com/sharkdp/fd)
[bat](https://github.com/sharkdp/bat)
