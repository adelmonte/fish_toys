# clear with no scrollback
function clear
    printf '\033[2J\033[3J\033[H' && commandline -f repaint
end
