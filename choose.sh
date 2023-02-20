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

    local indexChange=0
    while true
    do

        read -sn1 -p "" key
        if [[ $key == $'\e' ]] ; then
            read -sn1 -t 0.01 key
            if [[ "$key" == "[" ]] ; then
                read -sn1 -t 0.01 key
                case $key in
                    A)
                        ((mChooseIndex--))
                        indexChange=1
                        ;;
                    B)
                        ((mChooseIndex++))
                        indexChange=1
                        ;;
                esac
            fi
        fi


        if [[ $mChooseIndex -lt 0 ]]; then
            mChooseIndex=0
            indexChange=0
        fi

        if [[ $mChooseIndex -gt $mChooseMaxIndex ]]; then
            mChooseIndex=$mChooseMaxIndex
            indexChange=0
        fi


        if [[ $indexChange == 1 ]]; then
            indexChange=0
            tput rc
            showChoose
        fi

    done

    tput cnorm;
}
