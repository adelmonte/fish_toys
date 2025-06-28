function compress
   if test (count $argv) -eq 0; or contains -- --help $argv
       echo (set_color green)"Usage:"(set_color normal)" compress <source> [output]"
       echo
       echo (set_color cyan)"Examples:"(set_color normal)
       echo "  compress myfile.txt                # myfile.txt.tar.gz"
       echo "  compress myfile.txt backup.tar.xz  # backup.tar.xz"
       echo "  compress mydir/ archive.zip        # archive.zip"
       echo
       echo (set_color yellow)"Formats:"(set_color normal)
       echo "  .tar      - No compression"
       echo "  .tar.lz4  - Fastest"
       echo "  .tar.zst  - Fast, good ratio"
       echo "  .tar.gz   - Balanced (default)"
       echo "  .zip      - Cross-platform"
       echo "  .tar.bz2  - Better compression"
       echo "  .tar.xz   - Excellent compression"
       echo "  .7z       - High compression"
       echo "  .rar      - Proprietary"
       return 1
   end

   set -l source $argv[1]
   set -l output $argv[2]
   
   if not test -e $source
       echo (set_color red)"Error:"(set_color normal)" '$source' does not exist"
       return 1
   end
   
   # Default output
   if test -z "$output"
       set output (basename $source).tar.gz
   end
   
   # Extract format from extension
   set -l format (string replace -r '.*\.(tar\.)?(lz4|zst|gz|bz2|xz|tar|zip|7z|rar)$' '$2' $output)
   
   if test -z "$format"
       echo (set_color red)"Error:"(set_color normal)" Cannot determine format from '$output'"
       return 1
   end
   
   # Check tools
   switch $format
       case "lz4"
           if not command -v lz4 >/dev/null
               echo (set_color red)"Error:"(set_color normal)" lz4 not installed"
               return 1
           end
       case "zst"
           if not command -v zstd >/dev/null
               echo (set_color red)"Error:"(set_color normal)" zstd not installed"
               return 1
           end
       case "rar"
           if not command -v rar >/dev/null
               echo (set_color red)"Error:"(set_color normal)" rar not installed"
               return 1
           end
       case "7z"
           if not command -v 7z >/dev/null
               echo (set_color red)"Error:"(set_color normal)" 7z not installed"
               return 1
           end
   end
   
   # Create output directory
   set -l output_dir (dirname $output)
   if test "$output_dir" != "."; and not test -d $output_dir
       mkdir -p $output_dir
   end
   
   # Check overwrite
   if test -e $output
       echo -n (set_color yellow)"Overwrite"(set_color normal)" '$output'? [y/N] "
       read -n 1 response
       echo
       if not string match -qi "y" $response
           echo (set_color blue)"Aborted"(set_color normal)
           return 1
       end
   end
   
   # Compress
   switch $format
       case "gz"
           tar -czf $output -C (dirname $source) (basename $source)
       case "bz2"
           tar -cjf $output -C (dirname $source) (basename $source)
       case "xz"
           tar -cJf $output -C (dirname $source) (basename $source)
       case "zst"
           tar --zstd -cf $output -C (dirname $source) (basename $source)
       case "lz4"
           tar -cf - -C (dirname $source) (basename $source) | lz4 > $output
       case "tar"
           tar -cf $output -C (dirname $source) (basename $source)
       case "zip"
           set -l abs_output (realpath $output)
           cd (dirname $source)
           if test -d (basename $source)
               zip -qr $abs_output (basename $source)
           else
               zip -q $abs_output (basename $source)
           end
           cd - >/dev/null
       case "7z"
           set -l abs_output (realpath $output)
           cd (dirname $source)
           7z a -bd $abs_output (basename $source) >/dev/null
           cd - >/dev/null
       case "rar"
           set -l abs_output (realpath $output)
           cd (dirname $source)
           rar a -inul $abs_output (basename $source)
           cd - >/dev/null
       case '*'
           echo (set_color red)"Error:"(set_color normal)" Unsupported format '$format'"
           return 1
   end
   
   if test $status -eq 0
       echo (set_color green)"Created:"(set_color normal)" $output"
       if command -v du >/dev/null
           set -l sizes (du -sh $source $output 2>/dev/null | cut -f1)
           if test (count $sizes) -eq 2
               echo (set_color blue)"Size:"(set_color normal)" $sizes[1] → $sizes[2]"
           end
       end
   else
       echo (set_color red)"Failed"(set_color normal)
       return 1
   end
end
