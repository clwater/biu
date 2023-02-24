# /bin/bash

UitlsKeyUp="UP"
UitlsKeyDown="DOWN"
UitlsKeyLeft="LEFT"
UitlsKeyRight="RIGHT"
UitlsKeyQuit="QUIT"
UitlsKeyEnter="ENTER"

function utils.readArrow(){
    escape_char=$(printf "\u1b")
    read -rsn1 mode # get 1 character
    if [[ $mode == $escape_char ]]; then
        read -rsn2 mode # read 2 more chars
    fi
    case $mode in
        '[A') echo $UitlsKeyUp ;;
        '[B') echo $UitlsKeyDown ;;
        '[D') echo $UitlsKeyLeft ;;
        '[C') echo $UitlsKeyRight ;;
    esac
}

# get terminal size
UtilsCols=$(tput cols)
# ready clear line
UitlsEmptyLine=$(printf "%""$UtilsCols"s "")

UitlsRetuen=".temp/badReturn"

function utils.cache(){
    if [ -d .temp ]; then
        rm -rf .temp
    fi

    mkdir .temp
    touch $UitlsRetuen
}