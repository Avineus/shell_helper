#!/bin/bash


# To see the definitions in bash shell use type <fn name>
# $ type p4lbl

#
# p4lbl : Prints synced Label and Perforce's last label
function p4lbl()
{
    if [ -z "$P4ROOT" ]; then
        echo "P4ROOT is not set"
        return 1;
    fi
    path=`p4 client -o |grep '//' | grep SW | sed "s/\(.*\)$P4CLIENT\(.*\)SW.*.../\2/g"  | uniq`
    if [ -z "$path" ]; then
        # No SW path
        path=`p4 client -o |grep '//' | sed "s/\(.*\)$P4CLIENT\(.*\).*.../\2/g"  | head -n 1`
    fi
    #echo $path
    echo "Recent: "
    #p4 print $P4ROOT/MakeRls/build.setup | grep ^label= | cut -d ";" -f 1
    p4 print $P4ROOT${path}SW/MakeRls/build.setup | grep ^label= | cut -d ";" -f 1
    echo "Local: "
    #cat $P4ROOT/SW/MakeRls/build.setup | grep -e "^label=" -e"^#label=" | cut -d ";" -f 1
    cat $P4ROOT${path}SW/MakeRls/build.setup | grep -e "^label=" -e"^#label=" | cut -d ";" -f 1
    return 0;
}
export -f p4lbl

#
# p4add : add to default changelist
function p4add()
{
    if [ -z "$P4ROOT" ]; then
        echo "P4ROOT is not set"
        return 1;
    fi
    if [ -z "$1" ]
    then
        DIR=.
    else
        DIR=$1
    fi
    if [ -z "$2" ]
    then
        CL=default
    else
        CL=$2
    fi
    find $DIR -type f -print0 | xargs -0 p4 add -c $CL
    return 0;
}
export -f p4add

#
# p4v : Prints Perforce env
function p4v()
{
    echo Client: $P4CLIENT  Path: $P4ROOT
    if [ -n "$P4CLIENT" ]; then
        p4 client -o | grep "//"
    fi
}
export -f p4v


#
# o : Prints list of edited files and pending change lists
function o()
{
    ~/local/bin/p4open.sh
}
export -f o

#
# cl : Prints list of pending CLs
function cl()
{
    ~/local/bin/p4cl.sh $1
}
export -f cl

#
# od : Prints list of files not in any CLs
function od()
{
    if [ -z "$P4ROOT" ]; then
        echo "P4ROOT is not set"
        return 1;
    fi
    p4 opened -c default | cut -d' ' -f1 | cut -d'#' -f1
}
export -f od

#
# c : list the p4 clients
function c()
{
    if [ -n "$USER" ] ; then
        p4 clients -u $USER | awk '{print $2}' | cat -n 
    fi
    echo -n "Client name: "
    read input
    if [ -n "$input" ] ; then
        source ~/repo/p4bash.sh $input
        export NBSD_VERSION=5
        export E=$input
    fi
}
export -f c

#
# cclogin : login to code colloborator
function cclogin()
{
    if [ -n "$1" ] && [ -n "$2" ]
    then
        echo "Login..."
        ccollab login http://codecollab-sjc-01.force10networks.com:8080 $1 $2
    else
        if [ -z "$USER" ] ; then
            echo "USER is not set"
            return 1;
        fi
        ccollab login http://codecollab-sjc-01.force10networks.com:8080 $USER ""
    fi
    ccollab set scm perforce
}
export -f cclogin

#
# ccreview : edit a review
# Argument:  usage
#   $1 $2      new          <CL no>
#   $1         <review id> 
function ccreview()
{
    if [ -z "$1" ] || [ -z "$2" ]
    then
        echo "Usage: ccreview new|<review_id> <CL_no> [<cl no2>]"
        return
    fi
    if [ -z "$REVIEWER" ]
    then
        reviewer=pugalendran
    else
        reviewer=$REVIEWER
    fi
    PR=`p4 describe -s $2 | sed -n 's/PR\([0-9]*\).*/\1/p' | head -n 1`
    cclogin $USER ""
    ccollab addchangelist $@
    #if [ "$1" == "new" ]
    if [ "$1" == "$1" ]
    then
        ccollab admin review edit "last" --custom-field "P4 Describe Output=changelist $2"
        if [ -z "$P4BRANCH" ] 
        then
            ccollab admin review edit "last" --custom-field "Branch=Other"
        else
            ccollab admin review edit "last" --custom-field "Branch=$P4BRANCH"
        fi
        if [ -z "$PR" ] 
        then
            ccollab admin review edit "last" --custom-field "PR Number=00000"
        else
            ccollab admin review edit "last" --custom-field "PR Number=$2"
        fi
        echo -en "Reviewer (${reviewer}) : "
        read user_input
        if [ -n "$user_input" ] 
        then
            reviewer=$user_input
            valid=`phone -u $user_input -t | wc -l`
            if [ "$valid" -ne 1 ] 
            then
                echo "Please check reviewer id, suggestions are :"
                phone $user_input
            fi
        fi
        ccollab admin review set-participants "last" --participant  Author=antonyr  Reviewer=${reviewer}
        if [ $? -ne 0 ]
        then
            ccollab admin review finish "last"
        fi
    fi
}
export -f ccreview

#
# ccapprove : approve a review
# Argument:  usage
#   $1         <review id> 
function ccapprove()
{
    if [ -z "$1" ]
    then
        echo "Usage: ccapprove <review_id>"
        return
    fi
    cclogin $USER ""
    ccollab admin review finish $1
}
export -f ccapprove

#
# proxy_ccapprove : approve a review from another user
# Argument:  usage
#   $1         <review id> 
function proxy_ccapprove()
{
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
    then
        echo "Usage: ccapprove  <user> <pass> <review id>"
        return
    fi
    cclogin $1 $2
    ccollab admin review finish $3
}
export -f proxy_ccapprove

#
# dbg : Enable Debug for Compilation
# Argument:  none
function dbg()
{
    #
    # Build options
    export F10MKVERBOSE=1
    #
    # ICC Build options
    export GXX_ROOT=/tools/vendor/netbsd/5.0.0/bin
    export NETBSD_TOOLS=/tools/vendor/netbsd/5.0.0

}
export -f dbg
#
# undbg : Disable Debug for Compilation
# Argument:  none
function undbg()
{
    #
    # Build options
    unset F10MKVERBOSE
    #
    # ICC Build options
    unset GXX_ROOT
    unset NETBSD_TOOLS

}
export -f dbg


#
# snm : search nm
# Argument file path
function snm()
{
    if [ -z "$1" ] || [ -z "$2" ]
    then
        echo "Usage: snm <path> <pattern>"
        return
    fi
    for f in `find $1/*.o`
    do 
        cnt=`nm $f | grep $2 | grep  -c 'T'`; 
        if [ $cnt -ne 0 ]
        then
            echo "$f  ($cnt)"; 
        fi
    done    
}
export -f snm

#
# scanup: nmap scan host which are up
function scanup()
{
     #nmap -v -sP 10.16.30.0/24 |grep up
     if [ -z "$1" ]
     then
         echo "Usage: scanup [ip/subnet]"
         return
     fi
     nmap -v -sP $1 | grep up
}
export -f scanup

#
# Revert CVS
function revertcvs()
{
     if [ -z "$1" ]
     then
         dir=.
     else
         dir="$1"
     fi
     # find print %p-path %f-filename %s-size
     find $dir -name CVS -type d -printf '%p/...\r\n' | xargs p4 revert
}
export -f revertcvs

#
# Sum up numbers
function sum()
{
    # USage show pools
    # NGET = cat pool.log | grep nget |sed -e 's/.*nget \([0-9]*\).*nput \([0-9]*\)/\1/g' | sum
    # NPUT = cat pool.log | grep nget |sed -e 's/.*nget \([0-9]*\).*nput \([0-9]*\)/\2/g' | sum

    #OR using paste and bc
    #  cat pool.log | grep nget |sed -e 's/.*nget \([0-9]*\).*nput \([0-9]*\)/\2/g' | paste -sd+ | bc
    #OR
    # cat text | xargs  | sed -e 's/\ /+/g' | bc 

    awk '{total = total + $1}END{print total}'
}
export -f sum

#
# Csh setenv
function setenv()
{
    if [ -z "$1" ] || [ -z "$2" ]
    then
        echo "Usage: $0 <var> <value>"
        return
    fi
    export $1="$2"
}
export -f setenv
#
# Csh unsetenv
function unsetenv()
{
    if [ -z "$1" ]
    then
        echo "Usage: $0 <var>"
        return
    fi
    unset $1
}
export -f unsetenv

#
# Top 10 history commands
function top10()
{
    printf "COMMAND\tCOUNT\n"
    cat ~/.bash_history | awk '{ list[$1]++; } \
    END{
    for(i in list)
        {
            printf("%s\t%d\n",i,list[i]); }
        }' | sort -nrk 2 | head
}
export -f top10

#
# Script to calculate cpu usage by processe s for 1 hour
function pcpu_usage()
{
    SECS=3600
    UNIT_TIME=60

    STEPS=$(( $SECS / $UNIT_TIME ))
    echo Watching CPU usage... ;
    for((i=0;i<STEPS;i++))
    do
        ps -eo comm,pcpu | tail -n +2 >> /tmp/cpu_usage.$$
        echo CPU eaters [$i]:
        cat /tmp/cpu_usage.$$ | \
        awk '
        { process[$1]+=$2; }
        END{ 
        for(i in process)
            {
                printf("%-20s %s\n",i, process[i]) ;
            }
        }' | sort -nrk 2 | head

        sleep $UNIT_TIME
    done
    rm /tmp/cpu_usage.$$
}
export -f pcpu_usage
