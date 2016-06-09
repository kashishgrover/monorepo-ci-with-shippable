#!/bin/bash

#Shippable's Environment Variable which gives the current Commit ID
echo "COMMIT = $COMMIT"

#Put your image name over here
export IMAGE_NAME=kashish/samplenodejstwoapps

#Shippable's Environment Variable which gives the range between 
#the last successful Commit ID and the  current Commit ID
#in the form <COMMIT_ID_1>...<COMMIT_ID_2>
echo "SHIPPABLE_COMMIT_RANGE = $SHIPPABLE_COMMIT_RANGE"

#We can extract the previous commit ID using the Internal Field Separator (IFS) as '...'
COMMITPREV=$(IFS="..." ; set -- $SHIPPABLE_COMMIT_RANGE ; echo $1)
echo "COMMITPREV = $COMMITPREV"

#Store the list of files which have changed between the two commits within an array
readarray -t array <<< "$(git diff --name-only $COMMIT $COMMITPREV)" 

printf -- "%s\n" "${array[@]}"
printf "\n"

# A loop which is used to extract the directory names
# of the files which have changed between the two commits.
# For example, assume that the files AppFolder/foobar.js and
# shippable.yml in the project's main folder have changed.
# The array will consist of 'AppFolder' and 'shippable.yml'
i=0
for each in "${array[@]}"									
do															
	array[$i]=$(IFS="/" ; set -- $each ; echo $1)			
	echo ${array[$i]}										
	i=`expr $i + 1`											
done

#Now, we make sure that the folder names don't repeat and store the final unique words in anoher array
sorted_unique_first_words=$(echo "${array[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
IFS=' ' read -a WORD_ARRAY <<< "$sorted_unique_first_words"

#Get current directory
curdir=`pwd`

#The following FOR loop will check if a given word in the WORD_ARRAY is a directory or a file.
#	If it is a directory, push the repository with the tag name as the name of that particular directory
#	If it is a file, it means that the file has to exist in the main project folder. In this case, push the whole repository.

#Make sure that everything is in lowercase

for each in "${WORD_ARRAY[@]}"
do
	if [ -d $each ]
	then 
		echo "*IS A DIRECTORY***********************************************"
		pushd $curdir/"$each"/	
		echo "------------"
		#${each,,} will convert folder name to lowercase
		docker build -t $IMAGE_NAME:$BRANCH.${each,,}build .
		docker commit $SHIPPABLE_CONTAINER_NAME $IMAGE_NAME:$BRANCH.${each,,}build
		docker push $IMAGE_NAME:$BRANCH.${each,,}build
		echo "------------"
		popd
		echo "**************************************************************"
	else
		echo "*IS A FILE****************************************************"
		docker build -t $IMAGE_NAME:latest .
		docker commit $SHIPPABLE_CONTAINER_NAME $IMAGE_NAME
		docker push $IMAGE_NAME
		echo "**************************************************************"
	fi
done

#--------------#
