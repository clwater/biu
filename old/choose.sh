#! /bin/bash

source ./uitls.sh

ChooseKey="choose"

# choose input params
mChooseParams=()
# choose max index
mChooseMaxIndex=0
# choose index, use current select
mChooseIndex=0



# show choose test function: show all params
function choose.test(){
    for(( i=0;i<${#mChooseParams[@]};i++)) 
    do
        ((index++))
        echo ${mChooseParams[i]}
    done;
}



# show the choose params with list
# todo custom color
function showChoose(){
    for(( i=0;i<${#mChooseParams[@]};i++)) 
    do
        if [[ $mChooseIndex == $i ]]; then
            echo  -e "\033[36m> ${mChooseParams[i]} \033[0m" > /dev/tty 
        else
            echo  -e "\033[37m  ${mChooseParams[i]} \033[0m" > /dev/tty 
        fi
        ((index++))
    done;
}

# clear choose list 
function clearChoose(){
    tput rc
    for(( i=0;i<${#mChooseParams[@]};i++)) 
    do  
        # use read clear line for clear terminal
        # I try to use for echo or printf, but it slowly
        echo "$UitlsEmptyLine"
        ((index++))
    done;
    tput rc
}

# use choose.run to run choose function
function choose.run(){
    local _cols=`expr $UtilsCols - 2`
    # set params
    while read lineText
    do
        # split string, make it can show out fo the terminal
        local splitstr=${lineText: 0: $_cols}
        mChooseParams[${#mChooseParams[@]}]="$splitstr"
    done  < $1

    # set max index
    mChooseMaxIndex=${#mChooseParams[@]}
    ((mChooseMaxIndex--))

    # choose.test

    # tput set
    tput sc; tput civis 
    showChoose

    local indexChange=0
    # in while, waiting for use input Up, Down, Enter
    while true
    do

        # read key, check enter
        read -sn1 -p "" key
        if [[ $key = "" ]]; then 
            clearChoose
            echo "${mChooseParams[$mChooseIndex]}" > $UitlsRetuen
            break;
        fi
        # read key, check up, down
        # the up or down key is 3 char, so need read 3 char
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

        # check index, if index is out of range, set it to max or min
        if [[ $mChooseIndex -lt 0 ]]; then
            mChooseIndex=0
            indexChange=0
        fi

        if [[ $mChooseIndex -gt $mChooseMaxIndex ]]; then
            mChooseIndex=$mChooseMaxIndex
            indexChange=0
        fi

        # only when index change, show choose list
        if [[ $indexChange == 1 ]]; then
            indexChange=0
            tput rc
            showChoose
        fi

    done

    tput cnorm;
}
