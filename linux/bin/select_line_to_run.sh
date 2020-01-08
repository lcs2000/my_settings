#!/bin/sh
prog_name=$(basename $0)
usage()
{
    echo "Usage: $prog_name <file>" >&2
    echo "$prog_name: list commands fomr a given <file> and prompt for line number to be executed" >&2
    exit 1
}

[ $# != 1 ] && usage

file=$1
total_num=$(wc -l < $file)
#lines=$(seq $(wc -l < $file))
#    select num in "${lines[@]}";
#    do
#        awk
#    done
echo "Enter file number to be opened:"
read num
[[ "$num" =~ ^[0-9]+$ ]] || (echo "Sorry integers only" >&2;exit 1)
[ ${num} -gt ${total_num} ] && (printf "Sorry, file number is out of range(%s)\n" $total_num >&2; exit 1)

eval $(awk 'NR=='$num $file)