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
        while true
            set -l result (awk '
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
            ' ~/.ssh/config | fzf --header-lines=2 --height 100% --reverse \
                --bind 'del:execute-silent(echo {} | awk "{print \$1}" > /tmp/ssh_delete)+abort' \
                --header="Enter to connect, Del to remove entry")
            
            if test -f /tmp/ssh_delete
                set -l host_to_delete (cat /tmp/ssh_delete)
                rm -f /tmp/ssh_delete
                if test -n "$host_to_delete"
                    sed -i "/^Host $host_to_delete\$/,/^Host /{ /^Host $host_to_delete\$/d; /^Host /!d; }" ~/.ssh/config
                    sed -i "/^Host $host_to_delete\$/,/^\$/{/^Host $host_to_delete\$/d; /^\$/!d;}" ~/.ssh/config 
                    echo "Removed $host_to_delete from SSH config"
                    continue
                end
            else if test -n "$result"
                set -l host (echo "$result" | awk '{print $1}')
                commandline -r "ssh $host"
                break
            else
                break
            end
        end
    end
end
