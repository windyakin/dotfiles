#!/bin/bash

ESC="\033["
ESCEND=m
ESCOFF="\033[0m"

WORKDIR=$(cd $(dirname "${0}") && pwd)

if [ -z "${HOME}" ]; then
  HOME=$(cd ~ && pwd)
fi

SUCCESS="${ESC}32${ESCEND}Success${ESCOFF}"
INFO="${ESC}36${ESCEND}Info...${ESCOFF}"
SKIP="${ESC}34${ESCEND}Skip...${ESCOFF}"
WARNING="${ESC}33${ESCEND}Warning${ESCOFF}"
FAILED="${ESC}31${ESCEND}FAILED!${ESCOFF}"

function msg() {
  local MESSAGE=$(echo $@ | sed -e "s/\\\n/\n                              /g")
  echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] ${MESSAGE}" >&1
}

function err() {
  local MESSAGE=$(echo $@ | sed -e "s/\\\n/\n                              /g")
  echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] ${FAILED} $@" >&2
}

function make_symbolic_link() {
  if [ ! -e $1 ]; then
    ln -s $2 $1
    if [ $? -eq 0 ]; then
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
    if [ $? -eq 0 ]; then
      msg "${SUCCESS} Add execute authority $1"
    else
      err "Can not add execute authority $1"
      exit 1
    fi
  else
    msg "${SKIP} Add execute authority $1"
  fi
}

function command_install_check() {
  if [ ! -x "$(command -v $1)" ]; then
    msg "${WARNING} This environment is not installed '$1'\nPlease install by Homebrew"
  fi
}

# シンボリックリンクを貼る

make_symbolic_link $HOME/.zshrc $WORKDIR/.zshrc
make_symbolic_link $HOME/.gitconfig $WORKDIR/.gitconfig
make_symbolic_link $HOME/.tigrc $WORKDIR/.tigrc

mkdir -p $HOME/.peco
make_symbolic_link $HOME/.peco/config.json $WORKDIR/peco/config.json

msg "${INFO} Submodules update..."
cd $WORKDIR && git submodule update --init --recursive > /dev/null
msg "${SUCCESS} Submodules updated!"

add_execute_authority $WORKDIR/cool-peco/cool-peco

# ファイルをコピーする
msg "${INFO} Copy peco custom functions..."
cp $WORKDIR/peco/customs/* $WORKDIR/cool-peco/customs
msg "${SUCCESS} Copied!"

# ツール群存在チェック

if [ ! -x "$(command -v brew)" ]; then
  BREW_INSTALL_MSG="${WARNING} This environment is not installed 'brew'"
  msg "${BREW_INSTALL_MSG}\nGet Here! ==> ${ESC}4${ESCEND}https://brew.sh/${ESCOFF}"
fi

command_install_check peco
command_install_check tig
command_install_check rbenv
command_install_check rmtrash
command_install_check nodenv
command_install_check direnv
