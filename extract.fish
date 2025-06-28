function extract
   if test (count $argv) -eq 0; or contains -- --help $argv
       echo (set_color green)"Usage:"(set_color normal)" extract <archive> [archive2 ...]"
       echo
       echo (set_color yellow)"Formats:"(set_color normal)
       echo "  .tar.gz/.tgz, .tar.bz2/.tbz2, .tar.xz/.txz"
       echo "  .tar.zst/.tzst, .tar.lz4, .zip, .7z, .rar, .tar"
       return 1
   end

   for file in $argv
       if not test -f $file
           echo (set_color red)"Error:"(set_color normal)" '$file' not found"
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
           case "*.tar.lz4"
               lz4 -dc $file | tar xf -
           case "*.zip"
               unzip -q $file
           case "*.7z"
               7z x -bd $file >/dev/null
           case "*.rar"
               rar x -inul $file
           case "*.tar"
               tar xf $file
           case '*'
               echo (set_color red)"Error:"(set_color normal)" Unsupported format '$file'"
               continue
       end
       
       if test $status -eq 0
           echo (set_color green)"Extracted:"(set_color normal)" $file"
       else
           echo (set_color red)"Failed:"(set_color normal)" $file"
       end
   end
end
