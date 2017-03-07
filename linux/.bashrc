# .bashrc

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# fs setings
export WINDOWS_DISK="T:"    
export WINDOWS_EDITOR="notepad++"   
source ~/bin/fs.sh

# Setting the color of promt to red when login with root account,
# and green when login with non root account.
export PS1="\[\e[32;1m\][\u@\H \W]\$ \[\e[0m\]"
export PATH=~/tools/:~/bin:$PATH
export SVN_EDITOR=vi
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        #export TERM='xterm-color'
        export TERM='xterm'
fi

if ((BASH_VERSINFO[0] >= 4)) && ((BASH_VERSINFO[1] >= 2))
    then shopt -s direxpand
fi
#export LC_COLLATE="en_US.UTF-8"
#export LC_CTYPE="en_US.UTF-8"
#export LC_MESSAGES="en_US.UTF-8"
#export LC_MONETARY="en_US.UTF-8"
#export LC_NUMERIC="en_US.UTF-8"
#export LC_TIME="en_US.UTF-8"
#export LC_ALL="en_US.UTF-8"
#export TMUX_POWERLINE_PATCHED_FONT_IN_USE=true
export EDITOR='vim'
unset SSH_ASKPASS


NPROC=`nproc`


#---------------------------------------------------------------------------
#------                         alias                                -------
#---------------------------------------------------------------------------

# setting default path (DEF_PATH) for environment variable setting
DEF_PATH=$PATH
export DEF_PATH
export PATH
export USE_CCACHE=1

#ctags
alias mkctags='time ctags --extra=f --links=no --verbose -R . '
alias mkgtags='time gtags --skip-unreadable  --verbose '
function mkgtags_nolink()
{
    # $1 to set manually excluded folders seperated by comma (,) 
    linkFolders=$(find -type l -xtype d 2>/dev/null | awk '{ p=substr($0,2); gsub("/","\\/",p ); printf ( "%s\\/,", p)}')
    sed "s/:skip=/:skip=$1,$linkFolders/g" /etc/gtags.conf > gtags.conf;
    mkgtags
}
alias mkgtags_sdk2='mkgtags_nolink "kernel3-KERNEL_ML_3.4.*"'
alias mkgtags_android='mkgtags_nolink'
alias updgtags='time global -u' # To update gtags
function rpmEx() { rpm2cpio $1 | cpio -idmv; }


# for 97401c1 target board
alias stb97401r40=' export PATH=/opt/toolchains/crosstools_sf-linux-2.6.12.0_gcc-3.4.6-20_uclibc-0.9.28-20050817-20070131/bin:$DEF_PATH; export LINUX=/home/jack/svn/titanium/trunk/2612-4.0/stblinux-2.6.12; cd /home/jack/svn/titanium/trunk/refsw-20070327.97401; /bin/echo REF:source ./build_brutus.bash pisces101 y S21_VOD_CLIENT_SUPPORT=y DDR_256M=y VERIMATRIX_DRM=y install'
# for 97401b0 
alias stb97401r2b=' export PATH=/opt/toolchains/uclibc-crosstools_linux-2.6.12.0_gcc-3.4.2_uclibc-0.9.28-20060113/bin:$DEF_PATH; export LINUX=/home/jack/svn/titanium/trunk/2612-2.2/stblinux-2.6.12; cd /home/jack/svn/titanium/trunk/ipstb_20060804_97401_linux-2.6_r2_0b/; /bin/echo REF:time ./build_brutus.bash pisces101 y install S21_VOD_CLIENT_SUPPORT=y DDR_256M=y'
# for 97401a0
alias stb97401r2=' export PATH=/opt/toolchains/uclibc-crosstools_linux-2.6.12.0_gcc-3.4.2_uclibc-0.9.28-20060113/bin:$DEF_PATH; export LINUX=/home/jack/VSS/2612-2.1/stblinux-2.6.12; cd /home/jack/VSS/ipstb_20060501_97401_linux-2.6_r2_0/BSEAV/app/brutus/build; /bin/echo REF:time make PLATFORM=pisces101 BCHP_VER=A0 PLAYBACK_IP_SUPPORT=y DEBUG=y install'
# root fs linux kernel for 97401c1
alias linux261240=' export PATH=/opt/toolchains/crosstools_sf-linux-2.6.12.0_gcc-3.4.6-20_uclibc-0.9.28-20050817-20070131/bin:$DEF_PATH; cd /home/jack/svn/titanium/trunk/2612-4.0/; /bin/echo REF: source ./build.bash TFTPBOOT=~/tftpboot pisces102 install; date'
# root fs with linux kernel for 97401b0
alias linux261222=' export PATH=/opt/toolchains/uclibc-crosstools_linux-2.6.12.0_gcc-3.4.2_uclibc-0.9.28-20060113/bin:$DEF_PATH; cd /home/jack/svn/titanium/trunk/2612-2.2/uclinux-rootfs; /bin/echo REF: time make -f build.mk TFTPBOOT=~/tftpboot 7401b0 rootfs; date'
# root fs with linux kernel for 97401a0
alias linux261221=' export PATH=/opt/toolchains/uclibc-crosstools_linux-2.6.12.0_gcc-3.4.2_uclibc-0.9.28-20060113/bin:$DEF_PATH; cd /home/jack/VSS/2612-2.1/uclinux-rootfs; /bin/echo REF: time make -f build.mk TFTPBOOT=~/tftpboot 7401a0 rootfs; date'
# for ant galio
alias galio=' cd /home/jack/svn/titanium/trunk/ant_galio_s06-gi-wx-cjk/builds/bcm;/bin/echo REF:time ./build.bash pisces101 ipv6 all bdebug'
# system command
alias h='history'
#alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -al'
alias lm='ls -l --color=tty $* |more' 
alias svn_status="svn status|grep ^[^?]"
alias t19='cd /home/jack/svn/titanium/trunk/ant_galio_t19-gi-wx-cjk/'
alias brutus='cd /home/jack/svn/titanium/trunk/refsw-20070327.97401/'
alias kernel='cd /home/jack/svn/titanium/trunk/2612-4.0/'

#---------------------------------------------------------------------------
#------                         fucntion                             -------
#---------------------------------------------------------------------------

adbc()
{
  if [ "$1" == "" ] ; then
	echo "error: Please input target device IP!!"
  else 
  	adb connect $1 && adb root && sleep 1 && adb connect $1 && adb remount
  fi
}

svnmod()
{
##    /bin/echo "svn status | grep ^[^?\" \"]| awk '{status=substr(\$0, 0, 1); path=substr(\$0, 8);printf(\"%s--\n%s\n\",status,path)}' | convertpath"
    /bin/echo "svn status -q $*| awk -v disk=$DISK_LETTER -v root_path=\`pwd| sed 's;'\"\$HOME\"';;'\` '
                        BEGIN {printf(\"\\n\\n\")}
			{
			    status=substr(\$0, 0, 1);
			    path=root_path\"/\"substr(\$0, 9);
			    printf(\"-%s-\n%s%s\n\",status,disk,path)
			}
                        END {printf(\"\\n\\n\\nTotal %d files\\n\", NR)}' | sed 's;/;\\\\;g'"

##    svn status |grep ^[^?]|awk '{printf("%s--\n%s\n",$1,$2) }'|convertpath
##    svn status | grep ^[^?" "]| awk '{status=substr($0, 0, 1); path=substr($0, 8);printf("%s--\n%s\n",status,path)}' | convertpath
#    svn status | grep ^[^?" "]| awk '{
#	status=substr($0, 0, 1)
#	path=root_path"/"substr($0, 9)
#	gsub("/","\\",path )
#	printf("%s--\nZ:%s\n",status,path)}' \
#	root_path=`pwd` | sed 's/\\home\\Jack\\/\\/'

#    svn status | grep ^[^?" "]| awk -v root_path=`pwd | sed 's;'"$HOME"';;'` '{status=substr($0, 0, 1);
#        path=root_path"/"substr($0, 9);
#        printf("%s--\nZ:%s\n",status,path)}' | sed 's;/;\\;g'
     svn status -q $*| awk -v disk=$DISK_LETTER -v root_path=`pwd| sed 's;'"$HOME"';;'` '
                        BEGIN {printf("\n\n")}
                        { 
                           status=substr($0, 0, 1);
                           path=root_path"/"substr($0, 9);
                           printf("-%s-\n%s%s\n",status,disk,path)
                        }
                        END {printf("\n\n\nTotal %d files\n", NR)}' | sed 's;/;\\;g'
}


svnmodt()
{
#    svnmod |grep '^Z:' | awk 'BEGIN{printf("\n\nTortoiseProc.exe /command:repostatus /path:\"")} {if (NR==1) printf("%s",$1); else printf("*%s",$1)} END {printf("\"\n\n\nTotal %d files\n", NR)}'
    if [ "$#" -gt "0" ] ; then
        /bin/echo "Check for modifications in "$*
    fi
    svnmod $*|grep ^$DISK_LETTER | awk 'BEGIN{printf("Press <WIN>+Q and type \"svnmod\" to pop up TortoiseSVN window for modifications.\n\nTortoiseProc.exe /command:repostatus /path:\n\n\n\"")} {if (NR==1) printf("%s",$1); else printf("*%s",$1)} END {printf("\"\n\n\nTotal %d files\n", NR)}'
}

svnrm()
{
    /bin/echo "svn status | grep ^\?| awk '{print \$2}' | xargs --verbose -r rm -rf"
    svn status | grep ^\?| awk '{print $2}' | xargs --verbose -r rm -rf
}

gitmod()
{
     git status -s $*| awk -v disk=$DISK_LETTER -v root_path=`pwd| sed 's;'"$HOME"';;'` '
                        BEGIN {printf("\n\n")}
                        { 
						   status=$1;
                           path=root_path"/"$2;
						   gsub("/", "\\", path)
                           printf("-%s-\n%s%s\n",status,disk,path)
                        }
                        END {printf("\n\n\nTotal %d files\n", NR)}'
}


gitmodt()
{
#    gitmod |grep '^Z:' | awk 'BEGIN{printf("\n\nTortoiseProc.exe /command:repostatus /path:\"")} {if (NR==1) printf("%s",$1); else printf("*%s",$1)} END {printf("\"\n\n\nTotal %d files\n", NR)}'
    if [ "$#" -gt "0" ] ; then
        /bin/echo "Check for modifications in "$*
    fi
    gitmod $*|grep ^$DISK_LETTER | awk 'BEGIN{
			printf("Press <WIN>+Q and type \"gitmod\" to pop up TortoiseGIT window for modifications.\n\n")
			printf("TortoiseGitProc.exe /command:repostatus /path:\"")}
			{if (NR==1) printf("%s",$1); else printf("*%s",$1)} END {printf("\"\n\n\nTotal %d files\n", NR)}'
}


showerr()
{

    echo "$*"
    target=$1;
    shift
    #a2389.txt is just a random name so that we won't removed the file we don't want to remove
    ${target} $@ 2>a2389.txt; cat a2389.txt|convertpath | awk '{ if ($1=="error:") printf "%c[31;1m%s\n%c[0m",27, $0, 27; else print $0}';rm -f a2389.txt
}

# Indicate compile warning
showwarn()
{

    echo "$*"
    target=$1;
    shift
    #a2389.txt is just a random name so that we won't removed the file we don't want to remove
    ${target} $@ 2>a2389.txt; cat a2389.txt|convertpath | awk '{ if ($1=="warning:") printf "%c[31;1m%s\n%c[0m",27, $0, 27; else print $0}';rm -f a2389.txt
}


#function c7405 (Compile environment for 7405)
c7405()
{
    ## Last update: 2009/2/16
    ## History
    ##  2009/2/16:  Add extra_feature
    ##
    ##########   Edit your personal data begin ############################
    ### export environment variables for compiler use
    export TITLE="Compiling environment for 7405"
    export TOOLCHAINS_DIR=/opt/toolchains/crosstools_hf-linux-2.6.18.0_gcc-4.2-11ts_uclibc-nptl-0.9.29-20070423_20090508
    export UCLINUX_DIR=${HOME}/src/titanium/2618-7.1
    export GALIO_DIR=${HOME}/src/titanium/ant_galio_3.0.2-gi-wx-cjk
    export APPLIBS_DIR=


    ### set default option
    opt_vendor=""
    opt_kernel=""
    opt_brutus="noplaypump_ip mp3_full c99"
    opt_galio="mp3_full c99"
    opt_applibs="qtwebkit"

    ### setup following variables for help message
    src_dir=${HOME}/src/titanium
    galio_ver=ant_galio_3.1.7-gwi-wx-cjka
    brutus_ver=refsw-20110228.97405-r8.0
    kernel_ver=2618-7.1
    applibs_ver=applibs_release_20110311
    host_ip=10.10.10.30
    project=seediq
    while [ $# -gt 0 ]
    do
	case $1 in
	    "XTV106")
		    project="titanium"
    		model_name="XTV106"
        	;;
	    "xtv106")
		    project="titanium"
    		model_name="XTV106"
		;;
	    "xtv125")
    		project="titanium"
    		model_name=XTV125
		;;
	    "XTV125")
    		project="titanium"
    		model_name=XTV125
		;;
	    "xtv125h")
            project="titanium"
            model_name="XTV125h"
		;;
	    "XTV125h")
            project="titanium"
            model_name="XTV125h"
		;;
	    "xtv125hw")
            project="titanium"
            model_name="XTV125hw"
            opt_brutus="${opt_brutus} dlna"
		;;
	    "XTV125hw")
            project="titanium"
            model_name="XTV125hw"
            opt_brutus="${opt_brutus} dlna"
		;;
	    "XTV131")
    		project="seediq"
    		model_name=XTV131
    		kernel_ver=2637-2.5
    		export STBLINUX_VER=2.6.37
    		export TOOLCHAINS_DIR=/opt/toolchains/stbgcc-4.5.3-1.3
    		brutus_ver=refsw-20111201.97231-r30
    		opt_brutus="brutus noDNOT262A livestream"
    		extra_feature="noipv6 novc1 noavi"
    		opt_applibs="qtwebkit -j4"
    		applibs_ver=${brutus_ver}
		;;
	    "webkit")
            	opt_brutus="${opt_brutus} dlna"
		;;
	    "r65")
		    brutus_ver=refsw-20090807.97405-r6.5
		;;
	    "r8")
		    brutus_ver=refsw-20110228.97405-r8.0
		;;
	    "g2")
		    galio_ver=ant_galio_3.0.2-gi-wx-cjk
		;;
	    "g7")
		    galio_ver=ant_galio_3.1.7-gwi-wx-cjka
		;;
	    "g8")
		    galio_ver=ant_galio_3.1.8-gwi-wx-cjka
		;;
	    "gtd")
            opt_vendor="gtd"
            opt_kernel=""
            opt_brutus="${opt_brutus} verimatrix cg3210 dlna"
            opt_galio="${opt_galio} verimatrix cg3210 dlna mouse"
		;;
	    "debug")
            opt_brutus="${opt_brutus} bgdb debug"
            opt_galio="${opt_galio} ggdb gcdk bdebug"
		;;
	    "release")
#	    	src_dir=${HOME}/src/${project}/release/${model_name}
	    	project=${project}/release
		;;
	    *)
		    model_name=$1
		;;
	esac
	shift
    done

    src_dir=${HOME}/src/${project}/${model_name}
	UCLINUX_DIR=${src_dir}/${kernel_ver}
	GALIO_DIR=${src_dir}/${galio_ver}
	refsw_dir=${src_dir}/${brutus_ver}
	APPLIBS_DIR=${src_dir}/${applibs_ver}

    ### Add mipsel-linux-gcc path
    echo $PATH| grep -s $TOOLCHAINS_DIR/bin > /dev/null
    if [ "$?" != 0 ] ; then
        echo "No mipsel-linux-gcc path, add it!"
        export PATH=$TOOLCHAINS_DIR/bin:$PATH
        echo $PATH
    fi

    ##########   Edit your personal directory end #########################

#    if [ "$#" == 0 ] ; then
#        model_name=xtv125
#        extra_feature=
#    else
#        model_name=$1
#        extra_feature="$2 $3 $4 $5 $6 $7 $8 $9"
#    fi
    image_name=$model_name.img

    cd $refsw_dir
    /bin/echo "*******************************************************"
    /bin/echo "$TITLE"
    /bin/echo "*******************************************************"
    /bin/echo "export UCLINUX_DIR=${UCLINUX_DIR}"
    /bin/echo "export GALIO_DIR=${GALIO_DIR}"
    /bin/echo "export TOOLCHAINS_DIR=${TOOLCHAINS_DIR}"
    /bin/echo "refsw_dir=${refsw_dir}"
    /bin/echo ""
    /bin/echo -ne "\33[31;1mkernel:  \33[0m  \n"
    /bin/echo "./build.bash $model_name kernel $opt_vendor $opt_kernel"
    /bin/echo "./build.bash $model_name kernel rootfs image $opt_vendor $opt_kernel"
    /bin/echo -ne "\33[31;1mbrutus:  \33[0m  \n"
    /bin/echo "./build.bash $model_name $opt_brutus $opt_vendor $extra_feature"
    /bin/echo -ne "\33[31;1mapplibs:  \33[0m  \n"
    /bin/echo "./build.bash $model_name applibs $opt_brutus $opt_vendor $extra_feature qtwebkit"
    /bin/echo "./build.bash $model_name applibs $opt_brutus $opt_vendor $extra_feature qtwebkit-install"
    /bin/echo -ne "\33[31;1mgalio:  \33[0m  \n"
    /bin/echo "./build.bash $model_name galio $opt_galio $opt_vendor $extra_feature"
    /bin/echo -ne "\33[31;1mimage:  \33[0m  \n"
    /bin/echo "./build.bash $model_name $opt_brutus $opt_vendor $extra_feature install"
    /bin/echo -ne "\33[33;1mimage is '$image_name' and saved at $refsw_dir/BSEAV/bin \33[0m  \n"

    /bin/echo ""
    /bin/echo -ne "\33[31;1mupgrade:  \33[0m  \n"
    /bin/echo "At CFE:"
    /bin/echo "1. ifconfig eth0 -auto"
    /bin/echo "2. flash -noheader $host_ip:$image_name flash0.kernel"
    /bin/echo -ne "3. setenv -p STARTUP \"boot -z -tag -elf flash0.kernel: 'root=/dev/mtdblock0 ro mem=64M rootfstype=cramfs'\" \n"
    /bin/echo ""
    /bin/echo "At kernel:"
    /bin/echo "Usage:   upgrade [upgrade_url] [reboot]"
    /bin/echo "Example: upgrade ftp://$host_ip/$image_name 1"
}


#function c7231 (Compile environment for 7231)
c7231()
{
    ## Last update: 2009/2/16
    ## History
    ##  2009/2/16:  Add extra_feature
    ##
    ##########   Edit your personal data begin ############################
    ### export environment variables for compiler use
    export TITLE="Compiling environment for 7405"
    export TOOLCHAINS_DIR=/opt/toolchains/crosstools_hf-linux-2.6.18.0_gcc-4.2-11ts_uclibc-nptl-0.9.29-20070423_20090508
    export UCLINUX_DIR=${HOME}/src/titanium/2618-7.1
    export GALIO_DIR=${HOME}/src/titanium/ant_galio_3.0.2-gi-wx-cjk
    export APPLIBS_DIR=

    ### set default option
    opt_vendor=""
    opt_kernel=""
    opt_brutus="noplaypump_ip mp3_full c99"
    opt_galio="mp3_full c99"
    opt_applibs="qtwebkit"

    ### setup following variables for help message
    src_dir=${HOME}/src/titanium
    galio_ver=ant_galio_3.1.7-gwi-wx-cjka
    brutus_ver=refsw-20110228.97405-r8.0
    kernel_ver=2618-7.1
    applibs_ver=applibs_release_20110311
    host_ip=10.10.10.30
    project=seediq
    while [ $# -gt 0 ]
    do
	case $1 in
	    "XTV106")
    		src_dir=${HOME}/src/titanium/XTV106
    		model_name="XTV106"
        	;;
	    "xtv106")
    		src_dir=${HOME}/src/titanium/XTV106
    		model_name="XTV106"
		;;
	    "xtv125")
		    model_name=XTV125
		;;
	    "XTV125")
		    model_name=XTV125
		;;
	    "xtv125h")
		    model_name="XTV125h"
		;;
	    "XTV125h")
		    model_name="XTV125h"
		;;
	    "xtv125hw")
		    model_name="XTV125hw"
    		src_dir=${HOME}/src/${project}/${model_name}
            opt_brutus="${opt_brutus} dlna"
		;;
	    "XTV125hw")
		    model_name="XTV125hw"
    		src_dir=${HOME}/src/${project}/${model_name}
            opt_brutus="${opt_brutus} dlna"
		;;
	    "XTV131")
    		project="seediq"
    		model_name=XTV131
    		kernel_ver=2637-2.5
    		export STBLINUX_VER=2.6.37
    		export TOOLCHAINS_DIR=/opt/toolchains/stbgcc-4.5.3-1.3
    		brutus_ver=refsw-20111201.97231-r30
    		opt_brutus="brutus noDNOT262A livestream"
    		extra_feature="noipv6 novc1 noavi"
    		opt_applibs="qtwebkit -j4"
    		applibs_ver=${brutus_ver}
		;;
	    "XTV131_DVBC")
    		project="seediq"
    		model_name=XTV131_DVBC
    		kernel_ver=2637-2.5
    		export STBLINUX_VER=2.6.37
    		export TOOLCHAINS_DIR=/opt/toolchains/stbgcc-4.5.3-1.3
    		brutus_ver=refsw-20111201.97231-r30
    		opt_brutus="brutus noDNOT262A livestream"
    		extra_feature="noipv6 novc1 noavi"
    		opt_applibs="qtwebkit -j4"
    		applibs_ver=${brutus_ver}
		;;
	    "webkit")
    		src_dir=${HOME}/src/${project}/${model_name}
            opt_brutus="${opt_brutus} dlna"
		;;
	    "r45")
		    brutus_ver=refsw-20120503.97231-r45
    		    applibs_ver=${brutus_ver}
		;;
	    "r8")
		    brutus_ver=refsw-20110228.97405-r8.0
		;;
	    "g2")
		    galio_ver=ant_galio_3.0.2-gi-wx-cjk
		;;
	    "g7")
		    galio_ver=ant_galio_3.1.7-gwi-wx-cjka
		;;
	    "g8")
		    galio_ver=ant_galio_3.1.8-gwi-wx-cjka
		;;
	    "gtd")
            opt_vendor="gtd"
            opt_kernel=""
            opt_brutus="${opt_brutus} verimatrix cg3210 dlna"
            opt_galio="${opt_galio} verimatrix cg3210 dlna mouse"
		;;
	    "debug")
            opt_brutus="${opt_brutus} bgdb debug"
            opt_galio="${opt_galio} ggdb gcdk bdebug"
		;;
	    "release")
	    	project=${project}/release
		;;
	    *)
		    model_name=$1
		;;
	esac
	shift
    done

    src_dir=${HOME}/src/${project}/${model_name}
	UCLINUX_DIR=${src_dir}/${kernel_ver}
	GALIO_DIR=${src_dir}/${galio_ver}
	refsw_dir=${src_dir}/${brutus_ver}
	APPLIBS_DIR=${src_dir}/${applibs_ver}

    ### Add mipsel-linux-gcc path
    echo $PATH| grep -s $TOOLCHAINS_DIR/bin > /dev/null
    if [ "$?" != 0 ] ; then
        echo "No mipsel-linux-gcc path, add it!"
        export PATH=$TOOLCHAINS_DIR/bin:$PATH
        echo $PATH
    fi


    ##########   Edit your personal directory end #########################

#    if [ "$#" == 0 ] ; then
#        model_name=xtv125
#        extra_feature=
#    else
#        model_name=$1
#        extra_feature="$2 $3 $4 $5 $6 $7 $8 $9"
#    fi
    image_name=$model_name.img

    cd $refsw_dir
    /bin/echo "*******************************************************"
    /bin/echo "$TITLE"
    /bin/echo "*******************************************************"
    /bin/echo "export UCLINUX_DIR=${UCLINUX_DIR}"
    /bin/echo "export GALIO_DIR=${GALIO_DIR}"
    /bin/echo "export TOOLCHAINS_DIR=${TOOLCHAINS_DIR}"
    /bin/echo "refsw_dir=${refsw_dir}"
    /bin/echo ""
    /bin/echo -ne "\33[31;1mkernel:  \33[0m  \n"
    /bin/echo "./build.bash $model_name kernel image $opt_vendor $opt_kernel"
    /bin/echo -ne "\33[31;1mbrutus:  \33[0m  \n"
    /bin/echo "./build.bash $model_name $opt_brutus $opt_vendor $extra_feature"
    /bin/echo "./build.bash $model_name $opt_brutus $opt_vendor $extra_feature nexus_client"
    /bin/echo -ne "\33[31;1mapplibs:  \33[0m  \n"
    /bin/echo "./build.bash $model_name applibs $opt_applibs $opt_vendor $extra_feature"
    /bin/echo -ne "\33[31;1mgalio:  \33[0m  \n"
    /bin/echo "./build.bash $model_name galio $opt_galio $opt_vendor $extra_feature"
    /bin/echo -ne "\33[31;1mimage:  \33[0m  \n"
    /bin/echo "./build.bash $model_name $opt_brutus $opt_vendor $extra_feature install"
    /bin/echo -ne "\33[33;1mimage is '$image_name' and saved at $refsw_dir/BSEAV/bin \33[0m  \n"

    /bin/echo ""
    /bin/echo -ne "\33[31;1mupgrade:  \33[0m  \n"
    /bin/echo "At CFE:"
    /bin/echo "1. ifconfig eth0 -auto"
    /bin/echo "2. flash -noheader $host_ip:$image_name flash0.kernel"
    /bin/echo -ne "3. setenv -p STARTUP \"boot -z -tag -elf flash0.kernel: 'root=/dev/mtdblock0 ro mem=64M rootfstype=cramfs'\" \n"
    /bin/echo ""
    /bin/echo "At kernel:"
    /bin/echo "Usage:   upgrade [upgrade_url] [reboot]"
    /bin/echo "Example: upgrade ftp://$host_ip/$image_name 1"
}


#function c7241 (Compile environment for 7241)
c7241()
{
    ## Last update: 2009/2/16
    ## History
    ##  2009/2/16:  Add extra_feature
    ##
    ##########   Edit your personal data begin ############################
    ### export environment variables for compiler use
    export TITLE="Compiling environment for 7241"
    galio_ver=ant_galio_3.1.7-gwi-wx-cjka
    brutus_ver=refsw-20130612.unified-13.2
    kernel_ver=3.3-2.5
    applibs_ver=applibs_release_20110311
    project=amis
    src_dir=${HOME}/src/${project}
    model_name=XTV141
    local no_applibs=0
    export TOOLCHAINS_DIR=/opt/toolchains/stbgcc-4.5.3-2.4
    export UCLINUX_DIR=
    export GALIO_DIR=
    export APPLIBS_DIR=
    export STBLINUX_VER=

    ### set default option
    opt_vendor=""
    opt_kernel=""
    opt_brutus="noplaypump_ip mp3_full c99"
    opt_galio="mp3_full c99"

    ### setup following variables for help message
    host_ip=10.10.10.30
    while [ $# -gt 0 ]
    do
	case $1 in
	    "XTV141")
    		model_name=XTV141
            brutus_ver=refsw-20130612.unified-13.2
            kernel_ver=3.3-2.5
    		opt_brutus="atlas -j4"
    		extra_feature=
    		applibs_ver=${brutus_ver}
		;;
	    "release")
	    	project=${project}/release
		;;
	    "mfg")
	    	project=${project}/mfg
            no_applibs=1
		;;
	    "recovery")
	    	project=${project}/recovery
            no_applibs=1
		;;
	    *)
		    model_name=$1
		;;
	esac
	shift
    done

    src_dir=${HOME}/src/${project}/${model_name}
	UCLINUX_DIR=${src_dir}/${kernel_ver}
	refsw_dir=${src_dir}/${brutus_ver}
    STBLINUX_VER=${kernel_ver}
    [ $no_applibs == 0 ] && APPLIBS_DIR=${refsw_dir}

    ### Add mipsel-linux-gcc path
    echo $PATH| grep -s $TOOLCHAINS_DIR/bin > /dev/null
    if [ "$?" != 0 ] ; then
        echo "No mipsel-linux-gcc path, add it!"
        export PATH=$TOOLCHAINS_DIR/bin:$PATH
        echo $PATH
    fi


    ##########   Edit your personal directory end #########################

#    if [ "$#" == 0 ] ; then
#        model_name=xtv125
#        extra_feature=
#    else
#        model_name=$1
#        extra_feature="$2 $3 $4 $5 $6 $7 $8 $9"
#    fi
    image_name=$model_name.img

    cd $refsw_dir
    /bin/echo "*******************************************************"
    /bin/echo "$TITLE"
    /bin/echo "*******************************************************"
    /bin/echo "export UCLINUX_DIR=${UCLINUX_DIR}"
    /bin/echo "export TOOLCHAINS_DIR=${TOOLCHAINS_DIR}"
    /bin/echo "refsw_dir=${refsw_dir}"
    /bin/echo ""
    /bin/echo -ne "\33[31;1mkernel:  \33[0m  \n"
    /bin/echo "./build.bash $model_name kernel image $opt_vendor $opt_kernel"
    /bin/echo -ne "\33[31;1matlas:  \33[0m  \n"
    /bin/echo "./build.bash $model_name $opt_brutus $opt_vendor $extra_feature"
    /bin/echo -ne "\33[31;1mimage:  \33[0m  \n"
    /bin/echo "./build.bash $model_name $opt_brutus $opt_vendor $extra_feature nocmd install"
    /bin/echo -ne "\33[33;1mimage is '$image_name' and saved at $refsw_dir/BSEAV/bin \33[0m  \n"

    /bin/echo ""
    /bin/echo -ne "\33[31;1mupgrade:  \33[0m  \n"
    /bin/echo "At CFE:"
    /bin/echo "1. ifconfig eth0 -auto"
    /bin/echo "2. flash -noheader $host_ip:$image_name flash0.kernel"
    /bin/echo -ne "3. setenv -p STARTUP \"boot -tag -z -elf flash0.image: 'root=/dev/mtdblock0 rw bmem=192M@64M bmem=512M@512M rootfstype=squashfs brcmnand=rescan'\" \n"
    /bin/echo ""
    /bin/echo "At kernel:"
    /bin/echo "Usage:   upgrade [upgrade_url] [reboot]"
    /bin/echo "Example: upgrade ftp://$host_ip/$image_name 1"
}

function gettop
{
  local TOPFILE="BSEAV/build"
  [ $# -gt 0 ] && TOPFILE=$1  
    while [ $PWD != "/" ]
    do
        if [ -n "$PWD" -a -e "$PWD/$TOPFILE" ] ; then
        echo $PWD
        return
        fi
        cd ..
    done
}


function godir() {
    if [[ -z "$1" ]]; then
        echo "Usage: godir "
        return
    fi

    T=$(gettop)

 if [ -z $T ]; then
  echo "Cannot find the root directory which contains '$TOPFILE'"
  return
 fi
 

    if [[ ! -f $T/filelist ]]; then
        echo -n "Creating index..."
        (cd $T; find . -wholename ./out -prune -o -wholename ./.repo -prune -o -type f > filelist)
        echo " Done"
        echo ""
    fi
    local lines
    lines=($(\grep "$1" $T/filelist | sed -e 's/\/[^/]*$//' | sort | uniq))
    if [[ ${#lines[@]} = 0 ]]; then
        echo "Not found"
        return
    fi
    local pathname
    local choice
    if [[ ${#lines[@]} > 1 ]]; then
        while [[ -z "$pathname" ]]; do
            local index=1
            local line
            for line in ${lines[@]}; do
                printf "%6s %s\n" "[$index]" $line
                index=$(($index + 1))
            done
            echo
            echo -n "Select one: "
            unset choice
            read choice
            if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
                echo "Invalid choice"
                continue
            fi
            pathname=${lines[$(($choice-1))]}
        done
    else
        pathname=${lines[0]}
    fi
    cd $T/$pathname
}
function croot()
{
    T=$(gettop)
    if [ "$T" ]; then
        if [ "$1" ]; then
            \cd $(gettop)/$1
        else
            \cd $(gettop)
        fi
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
    fi
}

function cgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -name .svn -prune -o -name obj.* -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' \) \
        -exec grep --color -n "$@" {} +
}