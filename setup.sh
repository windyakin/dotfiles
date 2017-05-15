#!/bin/bash

ESC="\033["
ESCEND=m
ESCOFF="\033[0m"

SUCCESS="${ESC}32${ESCEND}Success${ESCOFF}"
SKIP="${ESC}34${ESCEND}Skip...${ESCOFF}"
WARNING="${ESC}33${ESCEND}Warning${ESCOFF}"
FAILED="${ESC}31${ESCEND}FAILED!${ESCOFF}"

function msg() {
  echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] $@" >&1
}

function err() {
  echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] ${FAILED} $@" >&2
}

function make_symbolic_link() {
  if [ ! -e $1 ]; then
    ln -s $2 $1
    if [ $? eq 0 ]; then
      msg "${SUCCESS} Make symbolic link $1"
    else
      err "Can not make symbolic link $1"
      exit 1
    fi
  else
    msg "${SKIP} Make symblic link $1"
  fi
}

function add_execute_authority() {
  if [ ! -x $1 ]; then
    chmod +x $1
    if [ $? eq 0 ]; then
      msg "${SUCCESS} Add execute authority $1"
    else
      err "Can not add execute authority $1"
      exit 1
    fi
  else
    msg "${SKIP} Add execute authority $1"
  fi
}

# シンボリックリンクを貼る

make_symbolic_link $HOME/.zshrc $HOME/dotfiles/.zshrc
make_symbolic_link $HOME/.gitconfig $HOME/dotfiles/.gitconfig
make_symbolic_link $HOME/.tigrc $HOME/dotfiles/.tigrc

mkdir -p $HOME/.peco
make_symbolic_link $HOME/.peco/config.json $HOME/dotfiles/peco/config.json

msg "Submodules update..."
git submodule update --init --recursive > /dev/null
msg "${SUCCESS} Submodules updated!"

chmod +x $HOME/dotfiles/cool-peco/cool-peco
msg "${SUCCESS} Added execute authority cool-peco"

# ツール群存在チェック

if [ ! -x "$(command -v peco)" ]; then
  msg "${WARNING} This environment is not installed 'peco'"
  echo -e "Get Here! ==> ${ESC}4${ESCEND}https://github.com/peco/peco/releases${ESCOFF}"
fi

if [ ! -x "$(command -v tig)" ]; then
  msg "${WARNING} This environment is not installed 'tig'"
fi

if [ ! -x "$(command -v brew)" ]; then
  msg "${WARNING} This environment is not installed 'brew'"
  case ${OSTYPE} in
    darwin*)
      echo -e "Get Here! ==> ${ESC}4${ESCEND}https://brew.sh/${ESCOFF}"
    ;;
    linux*)
      echo -e "Get Here! ==> ${ESC}4${ESCEND}http://linuxbrew.sh/${ESCOFF}"
    ;;
  esac
fi
