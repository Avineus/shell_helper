
#
# Environment common to all platforms.
#
MYPATH=/usr/local/bin:/work/sw/tools/f10tool:~/bin:/bin:/sbin:/usr/bin:/usr/sbin:/home/antonyr/local/bin:/home/antonyr/local/sbin:/tools/vendor/smartbear/bin/
export PATH=/home/antonyr/local/bin:${PATH}:${MYPATH}
export MANPATH=${MANPATH}:/usr/local/man
export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib
export PERL5LIB=/home/antonyr/local/perl/lib/:${PERL5LIB}

export SHELL=`which bash`
TCSH_SHELL=`which tcsh`

OS=`uname -s`

#
# Colors
#
#export LS_COLORS='no=01:di=01;35;01:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.sh=01;32:*.csh=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35:';
COLORS=/etc/DIR_COLORS
[ -e "$HOME/.DIR_COLORS" ] && COLORS="$HOME/.DIR_COLORS"
eval `dircolors --sh "$COLORS" 2>/dev/null`

#
# Aliases
#
alias   al="alias"
alias   h="history"

alias   ll="ls -l"
alias   la="ls -al"
alias   ltr="ls -ltr"
alias   so="source"
alias   m="more"
alias cp="cp -iv"
alias rm="rm -iv"
alias vi="vim"
alias emacs="emacs -nw -q"
alias tcsh="$TCSH_SHELL -f" # ignore ~/.cshrc
#alias "/usr/local/bin/tcsh"="/usr/local/bin/tcsh -f" # ignore ~/.cshrc
alias screen="screen"
alias yes="/bin/true"
alias no="/bin/false"

# Settings
if [ "$OS" = "Linux" ]; then
alias grep="grep --color=auto"
alias   ls='ls --color=auto -F'
alias   l='ls --color=no -F'
fi
alias   b='echo -e "\033[01;37m"'


set nonomatch
export DISPLAY=10.16.30.86:0.0
alias  xmsg="xmessage -nearmouse -timeout 2 Completed $_"
set correct=cmd
export EDITOR=vim
#clear
unset LANG

GREEN='\[\033[1;32m\]'
NC='\[\033[0m\]'

# Functions
export PS1="[\u@\h:\W]\$ "
export PS2="> "
#export PS2="[\t][\u@\h:\w]\$ "


#
# Include Functions
. ~/local/bin/bash_function.sh

#Make
#alias gmake="make --emake-emulation=gmake"
alias make="make --emake-annodetail= --emake-annofile= --emake-historyfile= --emake-logfile="


# P4
export SITE=`/usr/local/bin/site`
export P4PORT=p4sw1:1666
export P4PORT=p4swreplica-${SITE}-01:1666
export P4DIFF="diff -au"

alias main="source ~/repo/p4bash.sh ANT_IMAIN; export E=main; export NBSD_VERSION=5"
alias bios1="source ~/repo/p4bash.sh ANT_BIOS_1; export E=bios1"
alias ns1="source ~/repo/p4bash.sh ANT_NS1; export E=ns1; export NBSD_VERSION=5"
alias r2d2="source ~/repo/p4bash.sh ANT_R2D2; export E=r2d2; export NBSD_VERSION=5"
alias gpxe="source ~/repo/p4bash.sh GPXE; export E=gpxe;"
alias grub1="source ~/repo/p4bash.sh GRUB; export E=grub1;"
alias rain="source ~/repo/p4bash.sh ANT_RAIN_1; export E=rain; export NBSD_VERSION=5"
alias rain2="source ~/repo/p4bash.sh ANT_RAIN_2; export E=rain2; export NBSD_VERSION=5"
alias rain3="source ~/repo/p4bash.sh ANT_RAIN_3; export E=rain3; export NBSD_VERSION=5"
alias h1="source ~/repo/p4bash.sh ANT_HELIX; export E=h1; export NBSD_VERSION=5"
alias h2="source ~/repo/p4bash.sh ANT_HELIX2; export E=h2; export NBSD_VERSION=5"
alias p1="source ~/repo/p4bash.sh ANT_PIFIT_1; export E=p1; export NBSD_VERSION=5"
alias p2="source ~/repo/p4bash.sh ANT_PIFIT_2; export E=p2; export NBSD_VERSION=5"
alias a1="source ~/repo/p4bash.sh ANT_ARM_1; export E=a1; export NBSD_VERSION=5"

alias e='if [ "$E" != "" ]; then echo $E; fi'
alias u='unset P4CLIENT; unset P4BRANCH; unset P4ROOT'
alias axe="~/local/bin/axel.sh"

export  F10MKVERBOSE=0
title "$HOST"

