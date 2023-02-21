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

# ===bad way===
optFirst=$1

if [[ -f .temp_* ]]; then
    rm .temp_*
fi

pid=$$
tempFile=".temp_""$pid"
# tempFile=".temp_0000"

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
esac

rm $tempFile