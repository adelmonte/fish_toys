function copy
    set -g FISH_CLIPBOARD_FILE "$PWD/$argv[1]"
    set -g FISH_CLIPBOARD_OPERATION "copy"
    echo "Copied $FISH_CLIPBOARD_FILE to clipboard"
end
