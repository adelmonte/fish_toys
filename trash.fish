function trash
    set -l trash_dir "$HOME/.local/share/Trash/files"
    
    if test (count $argv) -eq 0
        # Check if trash is empty
        set -l trash_files (ls -A $trash_dir)
        if test (count $trash_files) -eq 0
            echo "Trash is empty."
            return
        end
        
        # Trash has contents - show and offer to empty
        echo "Trash contents:"
        ls -lh $trash_dir
        echo ""
        read -l -P "Do you want to empty the trash? [y/N] " confirm
        
        switch $confirm
            case Y y
                gio trash --empty
                echo "Trash emptied."
            case '' N n
                echo "Trash not emptied."
            case '*'
                echo "Invalid input. Trash not emptied."
        end
    else
        # Arguments provided: Use gio trash to move files to trash
        gio trash $argv
    end
end
