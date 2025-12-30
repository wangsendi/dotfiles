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
			stow -t "$HOME" "$_dir" --ignore="\.git"
		fi
	done

	echo "Done!"
}

__main() {
	__install
}

__main "$@"
