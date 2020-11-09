#!/bin/bash

NPROC=2
DISK_LETTER=T:
EXCLUDE_DIRS="-name .svn -o -name AppLibs -o -path ./BSEAV/bin -prune -o -path ./out -o -name .git -o -name .repo"
EXCLUDE_FILES="--exclude='*.d' --exclude='*.o' --exclude='*.so' --exclude='*.map' --exclude='ctags.tmp'"
EDITOR="notepad++"
fs()
{
    pattern="$1"
    option=
    if [ "$#" -gt "1" ] ; then
        shift
        option="$*"
    fi
    time find -type d \( ${EXCLUDE_DIRS} \) -prune -o -type f -print0 \
        | xargs -0 -P$NPROC grep -nIH ${EXCLUDE_FILES} --color=always $option "$pattern" \
        | awk -F':' -v edit=$EDITOR -v disk=$DISK_LETTER -v root_path=`pwd| sed 's;'"$HOME"';;'` '
                BEGIN {printf("Press <WIN>+Q and type \"np\" to open file in notepad++.\n\n\n")}
                {
                    path=root_path"/"$1
                    gsub("/", "\\", path)
                    printf("%s %s%s -n%s \n", edit, disk, path, $2)

                    # remove "...:...:"
                    sub("^[^:]*:[^:]*:","", $0)
                    printf("%s\n", $0)
                }
                END {printf("\n\n\nTotal %d files\n", NR)}'
}


fshelp()
{
    printf "**********\n"
    printf "fs\n"
    printf "~Jackie Yeh 2007/10/08\n"
    printf "**********\n"
    printf "shell function to find string in all subdirectory, exclude:\n"
    printf " -- binary files\n"
    printf " -- all files under .svn\n"
    printf " -- all files under .git\n"
    printf " -- all files under .repo\n"
    printf " -- *.d\n"
    printf " \n"
    printf "Usage:\n"
    printf "     fs <String> [other grep options]\n"
    printf "NOTE:\n"
    printf "     wildcard pattern: in.*de will match inde, incde, inclde, include, ...\n"
    printf "Default options:\n"
    printf "     -n      print line number with output lines\n"
    printf "     -r      handle directories recursive\n"
    printf "     -I      skip binary files\n"
    printf "     ---color=always      Always use colors on match\n"
    printf "Possible options:\n"
    printf "     -w      match only whole words\n"
    printf "     -i      ignore case distinctions\n"
    printf "     -e      use PATTERN as a regular expression\n"
    printf "     -l      only print FILE names containing matches\n"
    printf "     -NUM    print NUM lines of output context, NUM can be 1, 2, 3, ...\n"
    printf "     --include=PATTERN     files that match PATTERN will be examined\n"
    printf "     --exclude=PATTERN     files that match PATTERN will be skipped.\n"
    printf "     --color=never         don't use color. Useful for file output\n"
    printf "Example:\n"
    printf "     --Find 'layers_dbglist' in all subdirectories\n"
    printf "         fs layers_dbglist\n"
    printf "     --Find 'layers_dbglist' and \"match only whole words\" in all subdirectories\n"
    printf "         fs layers_dbglist -w\n"
    printf "     --Find 'layers_dbglist' and \"ignore the case\" in all subdirectories\n"
    printf "         fs layers_dbglist -i\n"
    printf "     --Find 'layers_dbglist' and \"print only filenames\" in all subdirectories\n"
    printf "         fs layers_dbglist -l\n"
    printf "     --Find 'layers_dbglist' and \"show 3 lines context\" in all subdirectories\n"
    printf "         fs layers_dbglist -3\n"
    printf "     --Find 'layers_dbglist' in \"*.c;*.cpp;*.h\" under all subdirectories\n"
    printf "         fs layers_dbglist --include='*.c*' --include='*.h'\n"
    printf "     --Find 'layers_dbglist' excluding \"*.h\" under all subdirectories\n"
    printf "         fs layers_dbglist --exclude='*.h'\n"
    printf "     --Find 'not modal' under all subdirectories\n"
    printf "         fs 'not modal'\n"
    printf " \n"
    printf " Variants of fs:\n"
    printf "     fsu(): find in current directory, no recursion\n"
    printf "     fsc(): find pattern only in '*.c'\n"
    printf "     fsh(): find pattern only in '*.h'\n"
    printf "     fsd(): find <function declaration> or <structure definition> in *.c or *.cpp or *.h\n"
    printf "     fsds(): find <structure definition> in *.c or *.cpp or *.h\n"

}


main()
{
    if [ "$#" -eq "1" ] ; then
        case "$1" in
            "-h")
              fshelp
              exit
              ;;
            "--help")
              fshelp
              exit
              ;;
            *) 
              ;;
        esac
    fi
    fs "$@"
}

main "$@"
