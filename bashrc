
# ~/.bashrc
#
battery_status(){
# change this path. The status and capacity files are stored in different locations on different devices.
# On my Xperia110 SailfishOS-phone it's stored in /sys/class/power_supply/battery
BATTERY=/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0C0A:00/power_supply/BAT0
BATSTATE=$(cat ${BATTERY}/status)
CHARGE=$(cat ${BATTERY}/capacity)
# The following color codes had issues on the original source were i found it.
# The color code need this escape secquences in octal format. Otherwise you will have problems with
# an selfoverwrting command prompt.
NON='\001\033[0m\002'
BLD='\001\033[1m\002'
RED='\001\033[1;31m\002'
GRN='\001\033[1;32m\002'
YEL='\001\033[1;33m\002'
COLOUR="$RED"
case "${BATSTATE}" in
  'Charged')
  BATSTT="$BLD=$NON"
  ;;
  'Charging')
  BATSTT="$BLD+$NON"
  ;;
  'Discharging')
  BATSTT="$BLD-$NON"
  ;;
esac
# prevent a charge of more than 100% displaying
if [ "$CHARGE" -gt "99" ]
then
CHARGE=100
fi
if [ "$CHARGE" -gt "15" ]
then
COLOUR="$YEL"
fi
if [ "$CHARGE" -gt "30" ]
then
COLOUR="$GRN"
fi
# You can use echo -e instead of the printf command. 
printf "[$COLOUR$CHARGE%% $NON$BATSTT]"
# On SailfishOS, fingerterm is the default terminal app. 
# There is an odd Problem with the first character of a string value in PS1 prompt.
# Maybe it is related to libreadline and the octal escape sequence \001 and \002.
# I leads to a wrong color for the first character of a string value when using 
# any character before the string value"
# Using havoc as a terminal app will work without problems.
# However, if you use fingerterm, you can move the $BATSTT value
# before the percentage value.
# This problem will ocur on SailfishOS/fingerterm only localy on the device. 
# You can use this line instead:
#printf "[$NON$BATSTT $COLOUR$CHARGE%%]" 
}

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# If id command returns zero, you got root access.
if [ $(id -u) -eq 0 ];
then # you are root, set red colour prompt
# Colorpromt beginns with \e or its octal equivalent \033.
# Each colorcode needs a escape sequence around it. This sequence starts 
# with \[ and ends with \]. The complete colorcode seqquence for one color should look like
# \[\033[1;34m\] 
# root is marked with color red, just as dangerous poisonous beasts in nature are often marked in red.
PS1='$(battery_status)\[\033[0;31m\]\u\[\033[1;31m\]@\h\[\033[1;34m\] \w\[\033[0m\]\$ '
# normal users become other colorcodes
else # normal user
PS1='$(battery_status)\[\033[1;36m\]\u\[\033[1;31m\]@\h\[\033[1;34m\] \w\[\033[0m\]\$ '
fi
