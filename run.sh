#!/usr/bin/env bash

set -euo pipefail

__install() {
	_dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	cd "$_dotfiles_dir"

	command -v stow >/dev/null 2>&1 || {
		echo "stow is not installed"
		exit 1
	}

	for _dir in */; do
		if [[ -d "$_dir" ]] && [[ ! "$_dir" =~ ^\.git ]]; then
			echo "Stowing $_dir..."
			# 先处理冲突文件
			while IFS= read -r -d '' _file; do
				_rel_path="${_file#"$_dir"}"
				_target="$HOME/$_rel_path"
				if [[ -e "$_target" ]] && [[ ! -L "$_target" ]]; then
					echo "  Backing up existing $_rel_path..."
					mv "$_target" "${_target}.bak.$(date +%s)"
				elif [[ -L "$_target" ]]; then
					rm "$_target"
				fi
			done < <(find "$_dir" -type f -not -path "*/\.git/*" -print0)

			stow -t "$HOME" -d "$_dotfiles_dir" "$_dir" --ignore="\.git"
		fi
	done

	echo "Done!"
}

__main() {
	__install
}

__main "$@"
