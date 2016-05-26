#!/bin/bash
#finding the list of folders that have changed with two given commit id's 

#read com1
#read com2
#readarray -t array <<< "$(git diff --name-only $com1 $com2)"
readarray -t array <<< "$(git diff --name-only HEAD HEAD~5)"

printf "Line 10\n"
printf -- "%s\n" "${array[@]}"

for each in "${array[@]}"
do
	printf "\nLine 15\n"
	word1=$(IFS="/" ; set -- $each ; echo $1)
	echo $word1
	
	if [ -d "$word1" ] 
	then 
		echo "**************************************************************"
		pushd /home/kashish/Desktop/SampleNodeJS_TwoApps/"$word1"/	
		echo "------------"
		docker build -t kashishgrover/${word1,,}build:latest .
		docker commit $SHIPPABLE_CONTAINER_NAME kashishgrover/${word1,,}build
		docker push kashishgrover/${word1,,}build:latest
		echo "------------"
		popd
		echo "**************************************************************"
	fi
done
echo "Hello"
