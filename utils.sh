# /bin/bash

mIsInit=0

UitlsCols=0

function Utils.init(){
    if [ $mIsInit == 0 ]; then
        mIsInit=1
        # get terminal cols
        UitlsCols=`tput cols`
    fi
}

