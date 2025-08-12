#!/bin/bash

set -euo pipefail

if [ -z "$N_WALLPAPER_DIRS" ]; then
    echo "ERROR: N_WALLPAPER_DIRS is not set." >&2
    echo "Please ensure it is exported from your .zshrc or .bashrc." >&2
    exit 1
fi

#  Read the colon-delimited string back into a Bash array.
#  This is the reverse of what we did in the .zsh.env file.
IFS=':' read -r -a wallpaper_directories <<<"$N_WALLPAPER_DIRS"

selected_dir=$(
    printf "%s\n" "${wallpaper_directories[@]}" | fzf --prompt="Select wallpaper directory: "
)

if [[ -z $selected_dir ]]; then
    echo "No directory selected"
    exit 0
fi

if [ -n "$TMUX" ]; then
    # 在 tmux 中使用 viu
    preview_cmd='viu -w 80 {}'
else
    # 在非 tmux 中使用 kitty icat
    preview_cmd='kitty +kitten icat --clear --transfer-mode=memory --place 80x40@140x5 --stdin < {} > /dev/tty'
fi

selected_image=$(
    find "$selected_dir" -mindepth 1 -maxdepth 1 -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" \) \
        -not -name '.DS_Store' |
        fzf --preview "$preview_cmd" \
            --preview-window=right:50%:wrap \
            --prompt="Select wallpaper image: "
)

if [[ -z $selected_image ]]; then
    echo "No image selected"
    exit 0
fi

BACKGROUND_IMAGE="$selected_image"

if [ ! -f "$BACKGROUND_IMAGE" ]; then
    echo "The selected file does not exist"
    exit 1
fi

echo "Setting background image to $BACKGROUND_IMAGE"
kitty @ set-background-image "$BACKGROUND_IMAGE" >/dev/null 2>&1 &
