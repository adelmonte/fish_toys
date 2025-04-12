function extract
    if test (count $argv) -eq 0; or contains -- --help $argv
        echo "Usage: extract <archive> [archive2 ...]"
        echo "Supports: tar.gz/tgz, tar.bz2/tbz2, tar.xz/txz,"
        echo "         tar.zst/tzst, zip, 7z, rar, tar"
        return 1
    end

    for file in $argv
        if not test -f $file
            echo "Error: '$file' does not exist"
            continue
        end

        switch $file
            case "*.tar.gz" "*.tgz"
                tar xzf $file
            case "*.tar.bz2" "*.tbz2"
                tar xjf $file
            case "*.tar.xz" "*.txz"
                tar xJf $file
            case "*.tar.zst" "*.tzst"
                tar --zstd -xf $file
            case "*.zip"
                unzip $file
            case "*.7z"
                7z x $file
            case "*.rar"
                rar x $file
            case "*.tar"
                tar xf $file
            case '*'
                echo "Unsupported format: $file"
                continue
        end
        
        if test $status -eq 0
            echo "Extracted $file"
        else
            echo "Failed to extract $file"
        end
    end
end
