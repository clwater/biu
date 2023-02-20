
isFirst=0
params=()
for i in "$@"; do
    if [ $isFirst != 0 ]; then
        params[${#params[@]}]="$i"
    fi  
    isFirst=1
done

toParams=""
for value in "${params[@]}"  
do  
    toParams="$toParams \"$value\""
done

echo $toParams