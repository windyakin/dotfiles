# 環境変数
export LANG=ja_JP.UTF-8

# 色を使用出来るようにする
autoload -Uz colors
colors

# Load other setting files
function loadlib() {
	lib=${1:?"You have to specify a library file"}
	if [ -f "$lib" ];then #ファイルの存在を確認
		. "$lib"
	fi
}

loadlib $HOME/dotfiles/zsh/export
loadlib $HOME/dotfiles/zsh/style
loadlib $HOME/dotfiles/zsh/history
loadlib $HOME/dotfiles/zsh/setopt
loadlib $HOME/dotfiles/zsh/theme
loadlib $HOME/dotfiles/zsh/bindkey
loadlib $HOME/dotfiles/zsh/alias


# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

FPATH="$FPATH:$HOME/dotfiles/cool-peco"
autoload -Uz cool-peco
cool-peco

if [ -f $HOME/dotfiles/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source $HOME/dotfiles/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

