function compress
    if test (count $argv) -eq 0; or contains -- --help $argv
        echo "Usage: compress <file/dir> [format]"
        echo "Default format: tar.gz"
        echo ""
        echo "Formats:"
        echo "  tar.zst, tzst  - Zstd tar archive (fastest compression/decompression, good ratio)"
        echo "  tar.lz4        - LZ4 tar archive (very fast, moderate compression)"
        echo "  tar.gz, tgz    - Gzip tar archive (good balance of speed/compression)"
        echo "  zip            - ZIP archive (most compatible across platforms)"
        echo "  tar.bz2, tbz2  - Bzip2 tar archive (better compression, slower than gzip)"
        echo "  7z             - 7-Zip archive (high compression, moderate speed)"
        echo "  rar            - RAR archive (good compression, proprietary format)"
        echo "  tar.xz, txz    - XZ tar archive (excellent compression, slower speed)"
        echo "  tar.lz         - LZMA tar archive (very high compression, slow)"
        echo "  tar.lrz        - LRZIP tar archive (best for large files >100MB, very slow)"
        echo "  tar            - Tar archive (no compression, just bundling)"
        return 1
    end

    set -l target $argv[1]
    set -l format "tar.gz"
    if test (count $argv) -gt 1
        set format $argv[2]
    end

    if not test -e $target
        echo "Error: '$target' does not exist"
        return 1
    end

    # Check if required compression tools are installed
    switch $format
        case "tar.lz4"
            if not command -v lz4 >/dev/null
                echo "Error: lz4 is not installed"
                return 1
            end
        case "tar.lrz"
            if not command -v lrzip >/dev/null
                echo "Error: lrzip is not installed"
                return 1
            end
        case "rar"
            if not command -v rar >/dev/null
                echo "Error: rar is not installed"
                return 1
            end
        case "7z"
            if not command -v 7z >/dev/null
                echo "Error: 7z is not installed"
                return 1
            end
    end

    set -l name (basename $target)
    
    switch $format
        case "tar.gz" "tgz"
            tar -czf "$name.tar.gz" $target
        case "tar.bz2" "tbz2"
            tar -cjf "$name.tar.bz2" $target
        case "tar.xz" "txz"
            tar -cJf "$name.tar.xz" $target
        case "tar.zst" "tzst"
            tar --zstd -cf "$name.tar.zst" $target
        case "tar.lz4"
            tar -cf - $target | lz4 > "$name.tar.lz4"
        case "tar.lz"
            tar --lzip -cf "$name.tar.lz" $target
        case "tar.lrz"
            tar -cf - $target | lrzip -o "$name.tar.lrz"
        case "zip"
            if test -d $target
                zip -r "$name.zip" $target
            else
                zip "$name.zip" $target
            end
        case "7z"
            7z a "$name.7z" $target
        case "rar"
            if test -d $target
                rar a "$name.rar" $target
            else
                rar a "$name.rar" $target
            end
        case "tar"
            tar -cf "$name.tar" $target
        case '*'
            echo "Unsupported format: $format"
            return 1
    end

    if test $status -eq 0
        echo "Successfully compressed as $name.$format"
    else
        echo "Failed to compress $target"
        return 1
    end
end
