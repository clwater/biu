#!/bin/bash

# Choose

choose=$(./biu.sh choose a "b c" "d \"e" f g h i jk l l2 mn  --limit=2)
echo $choose

# declare -A test

# test[a]=1
# test[b]=1
# test[c]=1

# # q: how to get key and value
# for key in $(echo ${!test[*]})
# do
#     echo "$key : ${test[$key]}"
# done

# test['a']=2

# for key in $(echo ${!test[*]})
# do
#     echo "$key : ${test[$key]}"
# done