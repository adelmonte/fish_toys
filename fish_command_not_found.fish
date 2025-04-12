function fish_command_not_found
    set -l cmd $argv[1]
    set -l args $argv[2..-1]
    if test -x ~/.config/fish/functions/core/command-not-found
        set -l output (~/.config/fish/functions/core/command-not-found $argv)
        if test $status = 127
            # Parse structured output
            set -l suggestions
            for line in $output
                if string match -q "SUGGESTION:*" $line
                    set -l parts (string split ':' $line)
                    set -a suggestions "$parts[3]"
                end
            end
            if test (count $suggestions) -gt 0
                echo "Command '$cmd' not found. Did you mean:"
                set -l i 1
                for suggestion in $suggestions
                    printf "  %d) %s\n" $i $suggestion
                    set i (math $i + 1)
                end
                read -P "Run command? [1-"(count $suggestions)"/N] " choice
                if string match -qr '^[0-9]+$' -- $choice
                    if test $choice -ge 1 -a $choice -le (count $suggestions)
                        set -l corrected $suggestions[(math $choice)]
                        echo "→ Running: $corrected $args"
                        # Remove 'command' to allow fish functions/aliases
                        eval "$corrected $args"
                        return $status
                    end
                end
            else
                echo "Command '$cmd' not found."
            end
            return 127
        end
    else
        echo "Command '$cmd' not found."
        return 127
    end
end