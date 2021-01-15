#!/usr/bin/bash

# Base tools
sudo apt install curl \
  tmux \
  zsh \
  -y

# Python2
sudo apt install python2 -y
curl https://bootstrap.pypa.io/get-pip.py | python2

# Python3
sudo apt install python3-dev python3-pip -y

# NVM & NPM && Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install --lts

# NeoVim 
sudo apt install neovim python3-neovim ripgrep -y
python2 -m pip install --user --upgrade pynvim
python3 -m pip install --user --upgrade pynvim
npm install -g neovim

# i3
sudo apt install i3 \
  i3blocks \
  liblinux-inotify2-perl \
  xss-lock \
  maim \
  xbacklight \
  -y

mkdir $HOME/.fonts
curl https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip -L -o yosemitefonts.zip
unzip yosemitefonts.zip
mv YosemiteSanFranciscoFont-master/*.ttf $HOME/.fonts/
rm -rf YosemiteSanFranciscoFont-master yosemitefonts.zip

# OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
chsh -s $(which zsh)

# dotfiles
ln -fs $HOME/dotfiles/.gitconfig $HOME/.gitconfig
ln -fs $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
ln -fs $HOME/dotfiles/.i3workspaceconfig $HOME/.i3workspaceconfig
ln -fs $HOME/dotfiles/.zshrc $HOME/.zshrc
ln -fs $HOME/dotfiles/i3 $HOME/.config/i3
ln -fs $HOME/dotfiles/nvim $HOME/.config/nvim

# NeoVim Plugins
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +PlugInstall +qall

# Terminal theme
sudo apt install dconf-cli uuid-runtime -y
git clone https://github.com/Mayccoll/Gogh.git gogh
export TERMINAL=gnome-terminal
. gogh/themes/gruvbox-dark.sh
rm -rf gogh
