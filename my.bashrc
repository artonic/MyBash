# ~/.bashrc: executed by bash(1) for non-login shells.

#Disable Fucking Bell in TTY Mode
case $(tty) in /dev/tty[0-9]*)
	setterm -blength 0;;
esac

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
#PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
PS1="{Profile} [\d]$ "
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'
#
# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#alias google-chrome='google-chrome --user-data-dir /home/travis'
alias fix='export PROMPT_COMMAND=""'
#alias git-cache="git config --global credential.helper 'cache --timeout=3600'"
#alias web='ssh -X web.profileenterprises.com'
#alias dev='ssh -X dev.profileenterprises.com'
#alias dev-git='ssh git@web.profileenterprises.com git'
#export PROMPT_COMMAND=""
export JAVA_HOME=/
#export PATH=$PATH:/opt/jdk1.7.0_75/bin/
#PATH=$PATH:/root/Android/Sdk/platform-tools/
#PATH=$PATH:/opt/gcc-arm-none-eabi-4_9-2014q4/bin/
export PATH=$HOME/.config/composer/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/Android/Sdk/platform-tools/:/opt/gcc-arm-none-eabi-4_8-2014q3/bin/:/opt/MyBash/my.bin
function MyTeslong
{
	mplayer -fps 30 -cache 128 -tv driver=v4l2:width=640:height=480:device=/dev/video0 tv://
}
function MyCopyFileSystem
{
	p=`pwd`
	cd /
	echo -n "Are you sure \"$1\" is the right location? (y/n)"
	read answer
	if echo "$answer" | grep -iq "^y" ;then
    		rsync --delete -aAXv --exclude="dev/*" --exclude="proc/*" --exclude="sys/*" --exclude="tmp/*" --exclude="run/*" --exclude="mnt/*" --exclude="media/*" --exclude="lost+found" --exclude="root/Exclude/*" / $1
		echo "Copying /usr/include/sys, rsync always misses it for some reason"
		cp -rp /usr/include/sys/* $1/usr/include/sys/
		echo "Done!"
	else
    		echo Bye!
	fi
	cd $p
}
function MyStageFileSystem
{
	p=`pwd`
	cd /
	tar -cvpf /root/Exclude/FS-Stage.tar.gz --directory=/ --exclude=dev --exclude=proc --exclude=sys --exclude=tmp --exclude=run --exclude=mnt --exclude=media --exclude=lost+found --exclude=root/Exclude --exclude=root/Projects --exclude=root/VirtualBox\ VMs .
	cd $p
}

function MyBashPull
{
	pwd=$(pwd)
	rep=$(dirname `readlink ~/.bashrc`)
	cd $rep
	git pull origin master
	cd $pwd
}

function we_are_in_git_work_tree {
    git rev-parse --is-inside-work-tree &> /dev/null
}

function parse_git_branch {
    if we_are_in_git_work_tree
    then
    local BR=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2> /dev/null)
    if [ "$BR" == HEAD ]
    then
        local NM=$(git name-rev --name-only HEAD 2> /dev/null)
        if [ "$NM" != undefined ]
        then echo -n "@$NM"
        else git rev-parse --short HEAD 2> /dev/null
        fi
    else
        echo -n $BR
    fi
    fi
}

function parse_git_status {
    if we_are_in_git_work_tree
    then
    local ST=$(git status --short 2> /dev/null)
    if [ -n "$ST" ]
    then echo -n " + "
    else echo -n " - "
    fi
    fi
}

function pwd_depth_limit_2 {
    if [ "$PWD" = "$HOME" ]
    then echo -n "~"
    else pwd | sed -e "s|.*/\(.*/.*\)|\1|"
    fi
}


COLBROWN="\[\033[1;33m\]"
COLRED="\[\033[1;31m\]"
COLCLEAR="\[\033[0m\]"

GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
END="\033[0m"

source /bin/git-completion.bash

# export all these for subshells
function Git_Prompt {
	git config --global credential.helper 'cache --timeout=360000'
	export -f parse_git_branch parse_git_status we_are_in_git_work_tree pwd_depth_limit_2
	export PS1="$COLRED<$COLBROWN \$(pwd_depth_limit_2)$COLRED\$(parse_git_status)$COLBROWN\$(parse_git_branch) $COLRED>$COLCLEAR "
	export TERM="xterm-color"
}

function Main_Prompt {
	#PS1="\[\033[0;33m\]\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`{Profile} [\`if [[ `pwd|wc -c|tr -d " "` > 18 ]]; then echo "\W"; else echo "\\w"; fi\`]\$\[\033[0m\] "; echo -ne "\033]0;`hostname -s`:`pwd`\007"
	PS1='\[\e[0;31m\]{\h} \u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[0;31m\]\$ \[\e[m\]'
}
function Prompt {

	GIT=false
	TREE="/"
	arr=$(pwd | tr "/" "\n")
	for x in $arr
	do
		#echo "> [$x]"
		TREE="$TREE$x/"
		if [ -d "$TREE/.git" ]
		then
			GIT=true
		fi
	done
	#echo $TREE
	if $GIT
	then
		Git_Prompt
	else
		Main_Prompt
	 fi
}
PROMPT_COMMAND='Prompt'
