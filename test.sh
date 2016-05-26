#!/bin/bash
#finding the list of folders that have changed with two given commit id's 

#read com1
#read com2
#readarray -t array <<< "$(git diff --name-only $com1 $com2)"
echo "COMMIT = $COMMIT"
echo "SHIPPABLE_COMMIT_RANGE = $SHIPPABLE_COMMIT_RANGE"
COMMITPREV=$(IFS="..." ; set -- $SHIPPABLE_COMMIT_RANGE ; echo $1)
echo "COMMITPREV = $COMMITPREV"
readarray -t array <<< "$(git diff --name-only $COMMIT $COMMITPREV)"

printf "Line 10\n"
printf -- "%s\n" "${array[@]}"

for each in "${array[@]}"
do
	$each = $(IFS="/" ; set -- $each ; echo $1)
	echo $each
done

sorted_unique_first_words=$(echo "${array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

curdir=`pwd`
echo $curdir

for each in "${sorted_unique_first_words[@]}"
do
	if [ -d "$word1" ] 
	then 
		echo "**************************************************************"
		pushd $curdir/"$word1"/	
		echo "------------"
		docker build -t kashishgrover/samplenodejstwoapps/${word1,,}build:latest .
		docker commit $SHIPPABLE_CONTAINER_NAME kashishgrover/samplenodejstwoapps/${word1,,}build
		docker push kashishgrover/samplenodejstwoapps/${word1,,}build:latest
		echo "------------"
		popd
		echo "**************************************************************"
	elif [ -f "$word1" ]
	then
		echo "**************************************************************"
		docker build -t kashishgrover/samplenodejstwoapps:latest .
		docker commit $SHIPPABLE_CONTAINER_NAME kashishgrover/samplenodejstwoapps
		docker push kashishgrover/samplenodejstwoapps
		echo "**************************************************************"
	fi
done
echo "Hello"
