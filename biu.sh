#!/bin/bash

source ./choose.sh
source ./config.sh



# use getopt to parse args
# -q: disable getopt's own error message
# -a: Make long options can use - or --
# -o: short options
# -l: long options
# --: other to show help.

ARGS=$(getopt -q -a -o vh -l version,help -- "$@")
[ $? -ne 0 ] && Config.help && exit 1
eval set -- "${ARGS}"
while true; do
    case "$1" in
    -h | --help)
        Config.help
        exit 1
        ;;
    -v | --version)
        Config.version
        exit 1
        ;;
    --)
        shift
        break
        ;;
    esac
    shift
done


# check params can be used 
checkBiuParams=$(Config.checkBiuParams $1)
if [[ $checkBiuParams != 0 ]]; then
    Config.help
fi

# get Biu type
optFirst=$1

# get Biu params
params=()

# Is check Biu type?
mJumpBiuParams=0

# add Biu params
for i in "$@"; do
    if [[ $mJumpBiuParams == 0 ]]; then
        mJumpBiuParams=1
        continue
    fi
    params[${#params[@]}]=$i
done


# run Biu.Choose
function Biu.Choose(){
    for i in "${params[@]}"; do
        Choose.setParma "$i"
    done
    Choose.run > /dev/tty 
    echo $(Utils.readTemp)
}


# # run command
case "$optFirst" in
    choose)
        Biu.Choose
        ;;
esac