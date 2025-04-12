# search tldr and man pages
function apro
    apropos -s 1 '' | \
    awk '{
        # Get the command name
        cmd = $1
        # Remove any parentheses content from command name
        sub(/ *\([^)]*\)/, "", cmd)
        
        # Get the description by removing the first field and any section number
        $1 = ""
        desc = $0
        sub(/^ *\([^)]*\) *- */, "", desc)  # Remove section number and dash
        sub(/^ */, "", desc)  # Clean up leading spaces
        
        # Format and print
        printf "%-25s %s\n", cmd, desc
    }' | \
    fzf --ansi \
        --preview '
            echo "=== TLDR ===" && \
            TERM=xterm-256color tldr --color=always {1} 2>/dev/null && \
            echo -e "\n=== MAN PAGE ===" && \
            man {1} 2>/dev/null || \
            echo "No documentation available"
        ' \
        --preview-window="right:60%:wrap" \
        --layout=reverse \
        --header 'Search commands (TLDR + man pages)' \
        --tiebreak=index \
        | awk '{print $1}' | read -l result
    and commandline -i "$result"
end
