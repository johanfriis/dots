function convert-to-webp
    set input_file $argv[1]
    set output_file (string replace -r '\.(jpg|jpeg|png)$' '.webp' $input_file)

    # Convert the image to WebP using cwebp
    cwebp "$input_file" -o "$output_file"
end
