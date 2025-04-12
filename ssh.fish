function ssh
    if count $argv > /dev/null
        if string match -q '*@*' $argv[1]
            set -l user (string split '@' $argv[1])[1]
            set -l host (string split '@' $argv[1])[2]
            
            if not grep -q "Host.*$host" ~/.ssh/config
                read -l -P "Save this connection to SSH config? [y/N] " confirm
                if test "$confirm" = "y"
                    set -l nickname (read -l -P "Enter nickname for this connection (default: $host): ")
                    if test -z "$nickname"
                        set nickname $host
                    end
                    echo -e "\nHost $nickname\n    HostName $host\n    User $user" >> ~/.ssh/config
                end
            end
        end
        command ssh $argv
    else
        # Parse config with fixed-width columns
        set -l host (awk '
            BEGIN {
                printf "%-20s %-20s %-10s\n", "HOST", "HOSTNAME", "USER"
                printf "%-20s %-20s %-10s\n", "----", "--------", "----"
            }
            /^Host [^*]/ {
                if (host != "") {
                    hosts[++count] = sprintf("%-20s %-20s %-10s", host, hostname, user)
                }
                host=$2
                hostname=""
                user=""
            }
            /HostName/ {hostname=$2}
            /User/ {user=$2}
            END {
                if (host != "") {
                    hosts[++count] = sprintf("%-20s %-20s %-10s", host, hostname, user)
                }
                for (i = count; i >= 1; i--) {
                    print hosts[i]
                }
            }
        ' ~/.ssh/config | fzf --header-lines=2 --height 100% --reverse | awk "{print \$1}")
        # not kitten ssh host
        if test -n "$host"
            commandline -r "ssh $host"
        end
    end
end
