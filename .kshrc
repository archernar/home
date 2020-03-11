export PS1=`whoami`@`hostname -s`:'$PWD>'
HOSTNAME=`hostname -s`
export TERM=xterm-256color
export PATH=$PATH:/usr/bin
mkdir -p ~/tools
export TOOLS=~/tools
WW=$((     $(tput cols)   /3       ))

confirm() {
      print -n "   Enter '10111' to confirm >> "
      read STRIN
      if [ "$STRIN" != "10111" ] ; then
          print "   Exiting - No Match"
          exit 1
      fi
}
# #######################################################################
# Mounts
#
mounter() {
#mounter wind /etc/time  /etc/time  l2-time 
HOST=`hostname -s`
if [[ ! -a $3 ]]; then
    print "Mount point/directory needs to be created"
    confirm
    sudo mkdir -p "$3"
    sudo chmod 777 "$3"
elif [[ ! -d $3 ]]; then
    echo "Mountpoint $3 already exists but is not a directory" 1>&2
fi

if mountpoint -q "$3"; then
     printf "Already Mounted: %s\n" $3
else
     SZ=$1"@"$2
     IP=`echo $1 | gawk -F: '{print $0}'`
     fping -c1 -t300 $IP 2>/dev/null 1>/dev/null
     if [ $? -eq 0 ] ; then
          sudo mount $1:$2 $3 -o noatime >/dev/null 2>&1
          if [ $? -eq 0 ] ; then
               printf "Mounted %-25s on %s\n" $SZ $HOST@$3
          else
               printf "Error Mounting %-25s on %s\n" $SZ $HOST@$3
          fi
     else
          printf "File Server (%s) not found\n" $1
     fi
fi
}

server=wind 
if nc -w 2 -z $server 22 2>/dev/null; then 
    print "$server ✓" 
    mounter $server  /etc/time            /etc/time
else
    print "$server ✗"
fi

alias vii='vi -o'
alias VIM='vim -u NONE'
alias VI='vim'

export HISTFILE=$HOME/.history
export HISTSIZE=1024
alias h='history'
set -o emacs
alias __A=`echo "\020"`     # up arrow = ^p = back a command
alias __B=`echo "\016"`     # down arrow = ^n = down a command
alias __C=`echo "\006"`     # right arrow = ^f = forward a character
alias __D=`echo "\002"`     # left arrow = ^b = back a character
alias __H=`echo "\001"`     # home = ^a = start of line
alias __Y=`echo "\005"`     # end = ^e = end of line

# #######################################################################
# setup PATH
# setup CLASSPATH
# pathamatic $M2 
# #######################################################################
pathamatic() {
     if [ -d "$1" ] ; then
          PATH="$1:$PATH"
          export PATH
     else
          NOTHING=0
     fi
}



pathamatic ./
pathamatic ~/tools
