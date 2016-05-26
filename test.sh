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
printf "\n"

i=0
for each in "${array[@]}"
do
	array[$i]=$(IFS="/" ; set -- $each ; echo $1)
	echo ${array[$i]}
	i=`expr $i + 1`
done

sorted_unique_first_words=$(echo "${array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
IFS=' ' read -a WORD_ARRAY <<< "$sorted_unique_first_words"

printf "\n"
printf "\n"
echo "FIRST WORD ARRAY"

for each in "${WORD_ARRAY[@]}"
do
	echo $each
	echo ""
done

curdir=`pwd`
echo $curdir

for each in "${WORD_ARRAY[@]}"
do
	if [ -d $each ]
	then 
		echo "*IS A DIRECTORY***********************************************"
		pushd $curdir/"$each"/	
		echo "------------"
		docker build -t kashishgrover/samplenodejstwoapps:${each,,}build .
		docker commit $SHIPPABLE_CONTAINER_NAME kashishgrover/samplenodejstwoapps:${each,,}build
		docker push kashishgrover/samplenodejstwoapps/${each,,}build:${each,,}build
		echo "------------"
		popd
		echo "**************************************************************"
	else
		echo "*IS A FILE****************************************************"
		docker build -t kashishgrover/samplenodejstwoapps:latest .
		docker commit $SHIPPABLE_CONTAINER_NAME kashishgrover/samplenodejstwoapps
		docker push kashishgrover/samplenodejstwoapps
		echo "**************************************************************"
	fi
done
echo "Hello"
