#! /bin/bash

# load config.sh to config biu info
source ./config.sh

# source ./choose.sh


# use getopt to parse args
# -q: disable getopt's own error message
# -a: Make long options can use - or --
# -o: short options
# -l: long options
# --: other to show help.

ARGS=$(getopt -q -a -o vh -l version,help -- "$@")
[ $? -ne 0 ] && config.help && exit 1
eval set -- "${ARGS}"
while true; do
    case "$1" in
    -h | --help)
        config.help
        exit 1
        ;;
    -v | --version)
        config.version
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
checkBiuParams=$(config.checkBiuParams $1)
if [[ $checkBiuParams != 0 ]]; then
    config.help
fi






# todo: bad This function is not good, 
# I want to transfer params to other function
# but It can not transfer char ", 
# so I use a bad way to transfer params to other function

# besides, I find i can not return value from function,
# besuse if i use return code, the I/O is block, and terminal can not show
# so, I only can use file to save the function's return value
# when you need get the value, you need invoke the get function

# ===bad way===
badRetuenValue=""
if [ -f $UitlsRetuen ]; then
    badRetuenValue=$(cat $UitlsRetuen)
fi


optFirst=$1

utils.cache

pid=$$
tempFile=".temp/""$pid"
# tempFile=".temp/0000"

touch $tempFile


isFirst=1
while [ -n "$1" ]
do
    if [ $isFirst == 0 ]; then
        echo "$1" >> $tempFile
        shift
        continue
    else
        isFirst=0
        shift
    fi

done
# ===bad way===


# config some info


# run command
case "$optFirst" in
    choose)
        choose.run $tempFile
        ;;
    get)
        echo $badRetuenValue
esac
