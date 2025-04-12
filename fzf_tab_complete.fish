function fzf_tab_complete
    # Get the current command and token
    set -l cmd (commandline -p)
    
    # Get fish's completions
    set -l complist (complete -C"$cmd")
    
    if test -z "$complist"
        # No completions, use default behavior
        commandline -f complete
        return
    end
    
    # Simply use fzf with the raw completions
    # but format the display with awk for nice columns
    set -l selection (printf "%s\n" $complist | 
                    awk -F'\t' '{
                        if (NF > 1) {
                            printf "%-50s %s\n", $1, $2
                        } else {
                            print $1
                        }
                    }' | 
                    fzf --height 40% --reverse)
    
    if test -n "$selection"
        # Extract just the first word (the completion)
        set -l completion (echo $selection | awk '{print $1}')
        
        # Replace current token with selection
        commandline -t ""
        commandline -i "$completion"
    end
    
    commandline -f repaint
end
