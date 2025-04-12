function _fzf_search_history --description "Search command history. Replace the command line with the selected command."
    # Merge history from other sessions unless in private mode
    if test -z "$fish_private_mode"
        builtin history merge
    end
    # Set default time format if not specified
    if not set --query fzf_history_time_format
        set -f fzf_history_time_format "%a, %b %d, %Y %H:%M:%S"
    end
    # Make sure fzf uses fish for preview commands
    set -x SHELL (command --search fish)
    # Setup regex for time prefix in history entries
    set -f time_prefix_regex '^.*? │ '
    # Search history and process selection
    set -f commands_selected (
        builtin history --null --show-time="$fzf_history_time_format │ " |
        fzf --read0 \
            --print0 \
            --multi \
            --scheme=history \
            --layout=reverse \
            --prompt="History> " \
            --query=(commandline) \
            --preview="string replace --regex '$time_prefix_regex' '' -- {} | fish_indent --ansi" \
            --preview-window="top:3:wrap" \
            $fzf_history_opts |
        string split0 |
        string replace --regex $time_prefix_regex ''
    )
    if test $status -eq 0
        commandline --replace -- $commands_selected
    end
    commandline --function repaint
end


# Original function commented out for reference
# function fzf_search_history --description "Search command history. Replace the command line with the selected command."
#     # Merge history from other sessions unless in private mode
#     if test -z "$fish_private_mode"
#         builtin history merge
#     end
#     # Set default time format if not specified
#     if not set --query fzf_history_time_format
#         set -f fzf_history_time_format "%a, %b %d, %Y %H:%M:%S"
#     end
#     # Default fzf appearance settings if not set
#     if not set --query FZF_DEFAULT_OPTS
#         set -x FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
#     end
#     # Make sure fzf uses fish for preview commands
#     set -x SHELL (command --search fish)
#     # Setup regex for time prefix in history entries
#     set -f time_prefix_regex '^.*? │ '
#     # Search history and process selection
#     set -f commands_selected (
#         builtin history --null --show-time="$fzf_history_time_format │ " |
#         fzf --read0 \
#             --print0 \
#             --multi \
#             --scheme=history \
#             --prompt="History> " \
#             --query=(commandline) \
#             --preview="string replace --regex '$time_prefix_regex' '' -- {} | fish_indent --ansi" \
#             --preview-window="bottom:3:wrap" \
#             $fzf_history_opts |
#         string split0 |
#         string replace --regex $time_prefix_regex ''
#     )
#     if test $status -eq 0
#         commandline --replace -- $commands_selected
#     end
#     commandline --function repaint
# end