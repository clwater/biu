# /bin/bash

mIsInit=0

UtilsCols=0

mTempFile=".temp"

function Utils.writeTemp(){
    echo $1 >> $mTempFile
}

function Utils.readTemp(){
    cat $mTempFile
}


function Utils.init(){
    if [ $mIsInit == 0 ]; then
        trap "rm $mTempFile; tput cnorm" EXIT
    
        mIsInit=1
        # get terminal cols
        # todo some time, `tput cols` will get an error value
        UtilsCols=`tput cols`

        if [ ! -f $mTempFile ]; then
            touch $mTempFile
        fi
    fi
}

Utils.init
