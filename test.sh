#finding the list of folders that have changed with two given commit id's 

#read com1
#read com2
#readarray -t array <<< "$(git diff --name-only $com1 $com2)"
readarray -t array <<< "$(git diff --name-only HEAD HEAD~1)"

printf -- "%s\n" "${array[@]}"

for each in "${array[@]}"
do
	if [ -d "$each" ] 
	then 
		echo "Directory!"
		echo "------"
		pushd /home/kashish/Desktop/SampleNodeJS_TwoApps/"$each"/	
		echo "------"	
		ls
		echo "------"
		docker build -t kashishgrover/${each,,}build:latest .
		echo "------"
		popd
	fi
done
