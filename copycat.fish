# Copy output and Cat to see it at same time
function copycat --description "Display file contents and copy to clipboard"
    cat $argv | tee /dev/tty | xclip -selection clipboard
end
