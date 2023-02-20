#! /bin/bash

ChooseKey="choose"


mChooseParams=()

function choose.test(){
    for(( i=0;i<${#mChooseParams[@]};i++)) 
    do
        ((index++))
        echo ${mChooseParams[i]}
    done;
}

function choose.run(){
    while read lineText
    do
        mChooseParams[${#mChooseParams[@]}]="$lineText"
    done  < $1

    choose.test

}
