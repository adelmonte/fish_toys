function cattree
    argparse 'h/help' -- $argv
    or return

    if set -q _flag_help
        echo "Usage: cattree [directory]"
        echo "Recursively display contents of all text files in directory"
        echo "(default: current directory)"
        echo ""
        echo "Options:"
        echo "  -h/--help  Show this help message"
        return 0
    end

    set dir "."
    if test (count $argv) -gt 0
        set dir $argv[1]
    end

    fd -t f . $dir | while read -l file
        if not file --mime-type "$file" | string match -q "*binary*"
            set_color --bold blue
            echo "=== $file ==="
            set_color normal
            cat "$file"
            echo -e "\n"
        end
    end
end
