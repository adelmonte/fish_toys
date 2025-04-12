function display_bottom_bar --description 'Display the bottom status bar'
    # Only run this function once per second to avoid performance issues
    set -l current_time (date +%s)
    if set -q __last_bottom_bar_time
        set -l time_diff (math "$current_time - $__last_bottom_bar_time")
        if test $time_diff -lt 1
            return
        end
    end
    set -g __last_bottom_bar_time $current_time
    
    # Get terminal dimensions
    set -l cols (tput cols)
    set -l lines (tput lines)
    
    # Save cursor position
    echo -en "\033[s"
    
    # Move to the bottom of the terminal
    echo -en "\033[""$lines"";0H"
    
    # Colors from your theme
    set -l bg "2B3240"          # Background
    set -l gray "485B6A"        # color8 (dark gray)
    set -l blue "81A1C1"        # color6 (blue)
    set -l green "9BCA96"       # color2 (green)
    set -l yellow "EACB8B"      # color3 (yellow)
    set -l magenta "C796C7"     # color5 (magenta)
    
    # Define the separator
    set -l separator \uE0BA
    
    # Get basic information
    set -l date (date "+%a, %B %d, %Y")
    set -l uptime (uptime -p | string replace -r '^up ' '')
    
    # Get private IP - simplified approach
    set -l private_ip "192.168.1.140"  # Default as a fallback
    command ip -o -4 addr show scope global | read -l ipline
    if test $status -eq 0
        echo $ipline | string match -r '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | read -l extracted_ip
        if test -n "$extracted_ip"
            set private_ip $extracted_ip
        end
    end
    
    # Public IP - use a simple cached approach
    set -l public_ip_file "$HOME/.cache/public_ip"
    set -l public_ip "Unknown"
    
    # Create cache directory if needed
    if not test -d "$HOME/.cache"
        mkdir -p "$HOME/.cache"
    end
    
    # Read cached IP if available
    if test -f "$public_ip_file"
        read -l cached_ip < "$public_ip_file"
        if test -n "$cached_ip"
            set public_ip $cached_ip
        end
    end
    
    # Update public IP in background less aggressively
    # This is the part that likely causes the %1 error
    if not set -q __ip_update_running; or test "$__ip_update_running" = "0"
        if not test -f "$public_ip_file"; or test (math "$current_time - "(stat -c %Y "$public_ip_file" 2>/dev/null || echo $current_time)) -gt 3600
            set -g __ip_update_running 1
            fish -c "
                curl -s -m 2 ifconfig.me > $public_ip_file 2>/dev/null
                or echo 'Unavailable' > $public_ip_file
                set -U __ip_update_running 0
            " &
            disown >/dev/null 2>&1
        end
    end
    
    # Construct the content with separators
    set -l content "$date $separator Uptime: $uptime $separator Pri-IP: $private_ip $separator Pub-IP: $public_ip"
    
    # Calculate padding for right alignment
    set -l padding (math $cols - (string length --visible "$content") - 1)
    
    # Display the bar
    set_color -b $gray
    echo -en "\033[K"
    
    # Print padding
    if test $padding -gt 0
        printf "%"$padding"s" " "
    end
    
    # Date segment
    set_color $green -b $gray
    echo -n $separator
    set_color $bg -b $green
    echo -n " $date "
    
    # Uptime segment
    set_color $yellow -b $green
    echo -n $separator
    set_color $bg -b $yellow
    echo -n " Uptime: $uptime "
    
    # Private IP segment
    set_color $blue -b $yellow
    echo -n $separator
    set_color $bg -b $blue
    echo -n " Pri-IP: $private_ip "
    
    # Public IP segment
    set_color $magenta -b $blue
    echo -n $separator
    set_color $bg -b $magenta
    echo -n " Pub-IP: $public_ip"
    
    # Fill the remaining space
    set_color -b $magenta
    echo -en "\033[K"
    
    # Reset and restore cursor
    set_color normal
    echo -en "\033[u\r"
end