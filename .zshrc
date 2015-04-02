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

loadlib ~/dotfiles/zsh/style
loadlib ~/dotfiles/zsh/history
loadlib ~/dotfiles/zsh/setopt
loadlib ~/dotfiles/zsh/theme
loadlib ~/dotfiles/zsh/keybind
loadlib ~/dotfiles/zsh/alias

