function paste
    if set -q FISH_CLIPBOARD_FILE
        set -l filename (string split '/' "$FISH_CLIPBOARD_FILE")[-1]
        set -l target_path "$PWD"
        
        if test (count $argv) -gt 0
            # Convert relative path to absolute path
            if string match -q '~*' -- $argv[1]
                set target_path (string replace '~' $HOME $argv[1])
            else if string match -q '/*' -- $argv[1]
                set target_path $argv[1]
            else
                set target_path "$PWD/$argv[1]"
            end
        end

        # Remove trailing slash if present
        set target_path (string replace -r '/$' '' $target_path)

        if test "$FISH_CLIPBOARD_OPERATION" = "copy"
            cp "$FISH_CLIPBOARD_FILE" "$target_path/$filename"
            echo "Pasted $filename to $target_path (copied)"
        else if test "$FISH_CLIPBOARD_OPERATION" = "cut"
            mv "$FISH_CLIPBOARD_FILE" "$target_path/$filename"
            echo "Pasted $filename to $target_path (moved)"
            set -e FISH_CLIPBOARD_FILE
            set -e FISH_CLIPBOARD_OPERATION
        end
    else
        echo "Clipboard is empty"
    end
end