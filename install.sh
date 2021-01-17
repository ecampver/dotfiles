#!/usr/bin/bash

NC='\033[0m' # no color
MSG_COLOR=$'\e[1;92m' # bright green
SEPARATOR='##############################################'

info() {
  printf "$MSG_COLOR\n%s\n%s\n%s\n\n$NC" $SEPARATOR "$1..." $SEPARATOR
}

core() {
  info 'Installing core tools (curl, tmux, zsh)'

  sudo apt install curl \
    tmux \
    zsh \
    -y
}

python_v2() {
  info 'Installing python2 deps'

  sudo apt install python2 -y

  curl https://bootstrap.pypa.io/get-pip.py | python2
}

python_v3() {
  info 'Installing python3 deps'

  sudo apt install python3-dev python3-pip -y
}

node_lts() {
  info 'Installing Node LTS'

  sudo apt install python3-dev python3-pip -y

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
  NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

  nvm install --lts
}

neovim() {
  info 'Installing NeoVim deps'

  sudo apt install neovim python3-neovim ripgrep -y

  python2 -m pip install --user --upgrade pynvim
  python3 -m pip install --user --upgrade pynvim
  npm install -g neovim

  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         #https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  nvim +PlugInstall +qall
}

i3wm() {
  info 'Installing i3 deps'

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
}

ohmyzsh() {
  info 'Installing OhMyZsh'

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  printf 'Set zsh as default shell...\n'
  chsh -s $(which zsh)
}

dotfiles() {
  info 'Symlinking dotfiles'

  declare -A ln_map
  ln_map=(
    ['.gitconfig']='.gitconfig'
    ['.tmux.conf']='.tmux.conf'
    ['.i3workspaceconfig']='.i3workspaceconfig'
    ['.zshrc']='.zshrc'
    ['i3']='.config/i3'
    ['nvim']='.config/nvim'
  )

  for key in "${!ln_map[@]}"; do
    target="$PWD/$key"
    link="$HOME/${ln_map[$key]}"
    echo "$link -> $target"
    ln -fs $target $link
  done
}

theming() {
  info 'Installing terminal theme'

  sudo apt install dconf-cli uuid-runtime -y

  git clone https://github.com/Mayccoll/Gogh.git gogh
  export TERMINAL=gnome-terminal
  . gogh/themes/gruvbox-dark.sh
  rm -rf gogh
}

steps=(
  core
  python_v2
  python_v3
  node_lts
  ohmyzsh
  i3wm
  dotfiles
  neovim
  theming
)

for step in "${steps[@]}"; do
  $step
done
