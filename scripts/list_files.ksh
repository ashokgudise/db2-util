for filename in *.gz; do
    echo "$filename"
    zcat "$filename" | grep 204266
done > file_list.out
