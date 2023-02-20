#! /bin/bash

source ./uitls.sh

ChooseKey="choose"


mChooseParams=()
mChooseMaxIndex=0

# show choose test function: show all params
function choose.test(){
    for(( i=0;i<${#mChooseParams[@]};i++)) 
    do
        ((index++))
        echo ${mChooseParams[i]}
    done;
}


mChooseIndex=0


function showChoose(){
    for(( i=0;i<${#mChooseParams[@]};i++)) 
    do
        if [[ $mChooseIndex == $i ]]; then
            echo  -e "\033[36m [√] ${mChooseParams[i]} \033[0m" 
        else
            echo  -e "\033[37m [ ] ${mChooseParams[i]} \033[0m" 
        fi
        ((index++))
    done;

}

# use choose.run to run choose function
function choose.run(){
    # set params
    while read lineText
    do
        mChooseParams[${#mChooseParams[@]}]="$lineText"
    done  < $1

    mChooseMaxIndex=${#mChooseParams[@]}
    ((mChooseMaxIndex--))

    # choose.test

    tput sc; tput civis 
    showChoose

    while true
    do
        escape_char=$(printf "\u1b")
        read -rsn1 mode # get 1 character
        if [[ $mode == $escape_char ]]; then
            read -rsn2 mode # read 2 more chars
        fi
        case $mode in
            '[A') ((mChooseIndex--)) ;;
            '[B') ((mChooseIndex++)) ;;
        esac


        if [[ $mChooseIndex -lt 0 ]]; then
            mChooseIndex=0
        fi

        if [[ $mChooseIndex -gt $mChooseMaxIndex ]]; then
            mChooseIndex=$mChooseMaxIndex
        fi


        tput rc

        showChoose

    done

    tput el; tput cnorm
}
