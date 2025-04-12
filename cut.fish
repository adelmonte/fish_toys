function cut
    set -g FISH_CLIPBOARD_FILE "$PWD/$argv[1]"
    set -g FISH_CLIPBOARD_OPERATION "cut"
    echo "Cut $FISH_CLIPBOARD_FILE to clipboard"
end
