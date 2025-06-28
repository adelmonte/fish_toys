function fzf_tab_complete
    # Get the current command and token
    set -l cmd (commandline -p)
    set -l token (commandline -t)
    
    # Get fish's completions
    set -l complist (complete -C"$cmd")
    
    if test -z "$complist"
        # No completions, use default behavior
        commandline -f complete
        return
    end
    
    # Use fzf to select a completion with the current token as initial query
    set -l result (printf "%s\n" $complist | 
                  awk -F'\t' '{
                      if (NF > 1) {
                          printf "%-50s %s\n", $1, $2
                      } else {
                          print $1
                      }
                  }' | 
                  fzf --height 40% --reverse --query="$token")
    
    if test -n "$result"
        # Extract completion, handling spaces and descriptions
        set -l completion (echo $result | sed 's/  *.*$//')
        
        # Escape spaces for shell
        set -l escaped (string escape -- "$completion")
        
        # Clear the current token and insert the escaped completion
        commandline -t ""
        commandline -i -- "$escaped"
    end
    
    # Repaint the commandline
    commandline -f repaint
end
