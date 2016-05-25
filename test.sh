#finding the list of folders that have changed with two given commit id's 

read com1
read com2

readarray -t array <<< "$(git diff --name-only $com1 $com2)"

printf -- "%s\n" "${array[@]}"
