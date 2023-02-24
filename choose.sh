#!/bin/bash


mChooseList=(1 2 3)
mChooseIndex=1

# Choose


# clear choose list 
function clearChoose(){
    tput rc
    tput cup 0 0 
    for(( i=0;i<${#mChooseList[@]};i++)) 
    do  
        # use read clear line for clear terminal
        # I try to use for echo or printf, but it slowly
        echo "#######################################################" > /dev/tty
        ((index++))
    done;
    tput rc
}

function showChoose(){
    tput rc
    clearChoose
    for(( i=0;i<${#mChooseList[@]};i++)) 
    do
        if [[ $mChooseIndex == $i ]]; then
            echo  -e "\033[36m> ${mChooseList[i]} \033[0m" > /dev/tty 
        else
            echo  -e "\033[37m  ${mChooseList[i]} \033[0m" > /dev/tty 
        fi
        ((index++))
    done;
}




function checkInput(){
    while true
    do

        # read key, check enter
        read -sn1 -p "" key
        if [[ $key = "" ]]; then 
            echo "key enter and return this"
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
                        # echo "A" > /dev/tty
                         ((mChooseIndex--))
                        ;;
                    B)
                        # echo "B" > /dev/tty
                         ((mChooseIndex++))
                        ;;
                esac
            fi
        fi
        showChoose
        done
}

function Choose.run(){
    echo "Choose.run" > /dev/tty
    tput sc;
    showChoose
    checkInput
}