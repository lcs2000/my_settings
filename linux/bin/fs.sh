#!/bin/bash

NPROC=`nproc`
DISK_LETTER=T:
EXCLUDE_DIRS="-name '.svn' -o -name 'AppLibs' -o -path './BSEAV/bin' -o -path './out' -o -name '.git' -o -name '.repo'"
EXCLUDE_FILES="--exclude='*.d' --exclude='*.o' --exclude='*.so' --exclude='*.map' --exclude='ctags.tmp'"

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
        | awk -F':' -v disk=$DISK_LETTER -v root_path=`pwd| sed 's;'"$HOME"';;'` '
                BEGIN {printf("Press <WIN>+Q and type \"np\" to open file in notepad++.\n\n\n")}
                {
                    path=root_path"/"$1
                    gsub("/", "\\", path)

                    printf("%s%s -n%s \n", disk, path, $2)

                    # remove "...:...:"
                    content=$0
                    sub("^[^:]*:[^:]*:","",content)

                    printf("%s\n", content)
                }
                END {printf("\n\n\nTotal %d files\n", NR)}'
}


fshelp()
{
echo "**********"
echo "fs"
echo "~Jackie Yeh 2007/10/08"
echo "**********"
echo "shell function to find string in all subdirectory, exclude:"
echo " -- binary files"
echo " -- all files under .svn"
echo " -- all files under .git"
echo " -- all files under .repo"
echo " -- *.d"
echo " "
echo "Usage:"
echo "     fs <String> [other grep options]"
echo "NOTE:"
echo "     wildcard pattern: in.*de will match inde, incde, inclde, include, ..."
echo "Default options:"
echo "     -n      print line number with output lines"
echo "     -r      handle directories recursive"
echo "     -I      skip binary files"
echo "     ---color=always      Always use colors on match"
echo "Possible options:"
echo "     -w      match only whole words"
echo "     -i      ignore case distinctions"
echo "     -e      use PATTERN as a regular expression"
echo "     -l      only print FILE names containing matches"
echo "     -NUM    print NUM lines of output context, NUM can be 1, 2, 3, ..."
echo "     --include=PATTERN     files that match PATTERN will be examined"
echo "     --exclude=PATTERN     files that match PATTERN will be skipped."
echo "     --color=never         don't use color. Useful for file output"
echo "Example:"
echo "     --Find 'layers_dbglist' in all subdirectories"
echo "         fs layers_dbglist"
echo "     --Find 'layers_dbglist' and "match only whole words" in all subdirectories"
echo "         fs layers_dbglist -w"
echo "     --Find 'layers_dbglist' and "ignore the case" in all subdirectories"
echo "         fs layers_dbglist -i"
echo "     --Find 'layers_dbglist' and "print only filenames" in all subdirectories"
echo "         fs layers_dbglist -l"
echo "     --Find 'layers_dbglist' and "show 3 lines context" in all subdirectories"
echo "         fs layers_dbglist -3"
echo "     --Find 'layers_dbglist' in \"*.c;*.cpp;*.h\" under all subdirectories"
echo "         fs layers_dbglist --include='*.c*' --include='*.h'"
echo "     --Find 'layers_dbglist' excluding \"*.h\" under all subdirectories"
echo "         fs layers_dbglist --exclude='*.h'"
echo "     --Find 'not modal' under all subdirectories"
echo "         fs 'not modal'"
echo " "
echo " Variants of fs:"
echo "     fsu(): find in current directory, no recursion"
echo "     fsc(): find pattern only in '*.c'"
echo "     fsh(): find pattern only in '*.h'"
echo "     fsd(): find <function declaration> or <structure definition> in *.c or *.cpp or *.h"
echo "     fsds(): find <structure definition> in *.c or *.cpp or *.h"

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
