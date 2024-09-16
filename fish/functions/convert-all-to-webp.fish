function convert-all-to-webp
    set input_directory $argv[1]
    fd $input_directory -t f -e png -e jpg -e jpeg -x cwebp {} -o {.}.webp
end
