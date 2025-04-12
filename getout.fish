# Copt Terminal Out - remove extent=all for no scrollback
function getout
    set -l clipboard_cmd
    
    # Determine clipboard command
    if type -q xclip
        set clipboard_cmd "xclip -selection clipboard"
    else if type -q xsel
        set clipboard_cmd "xsel --clipboard --input"
    else
        echo "No clipboard tool found. Please install xclip, xsel, or use macOS/WSL"
        return 1
    end

    # Try terminal-specific methods
    if set -q KITTY_WINDOW_ID
        kitty @ get-text --extent=all | eval $clipboard_cmd
    else if test -n "$TMUX"
        tmux capture-pane -pJ | eval $clipboard_cmd
    else
        history | eval $clipboard_cmd
    end
    
    echo "Output copied to clipboard"
end
