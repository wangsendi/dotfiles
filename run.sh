#!/usr/bin/env bash

set -euo pipefail

__main() {
	# 检查并安装 stow
	command -v stow >/dev/null 2>&1 || apt install -y stow

	# 获取 dotfiles 目录
	_dotfiles_dir="${DOTFILES_DIR:-$HOME/.dotfiles}"

	# 如果不存在就 clone
	if [[ ! -d "$_dotfiles_dir" ]]; then
		git clone https://github.com/wangsendi/dotfiles.git "$_dotfiles_dir"
	else
		git -C "$_dotfiles_dir" pull
	fi

	cd "$_dotfiles_dir"

	# 执行 stow
	for _dir in */; do
		[[ -d "$_dir" ]] && [[ ! "$_dir" =~ ^\.git ]] || continue
		echo "Stowing $_dir..."
		stow -t "$HOME" -d "$_dotfiles_dir" "$_dir" --ignore="\.git"
	done

	echo "Done!"
}
