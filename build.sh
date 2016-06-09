#!/bin/bash

SHIPPABLE_COMMIT_RANGE=7ce5782c58a8d5496c3fffe6bee11b6a62a035f4...a3f011963671bc3057f2170f6bc16ab9465980e7
echo $SHIPPABLE_COMMIT_RANGE 

#Put your image name over here
export IMAGE_NAME=kashishgrover/samplenodejstwoapps

detect_changed_files_and_folders() {
  echo "Detecting Changes For This Build"

  #SHIPPABLE_COMMIT_RANGE is an Environment Variable which
  #gives the range between the last successful Commit ID and
  #the  current Commit ID as <COMMIT_ID_1>...<COMMIT_ID_2>

  array=`git diff --name-only $SHIPPABLE_COMMIT_RANGE | sort -u | awk 'BEGIN {FS="/"} {print $1}' | uniq`
  printf -- "%s\n" "${array[@]}"
  printf "\n"
  for element in $array
  do
    build_and_push_changed_folder $element
  done
  for element in $array
  do
    build_and_push_main
    break
  done
}

build_and_push_changed_folder() {
  if [ -d $1 ]; then
    echo "*THIS IS A DIRECTORY******************************************"
    curdir=`pwd`
    pushd $curdir/"$1"/
    #${1,,} will convert folder name to lowercase
    docker build -t $IMAGE_NAME:$BRANCH.${1,,}build .
    docker commit $SHIPPABLE_CONTAINER_NAME $IMAGE_NAME:$BRANCH.${1,,}build
    docker push $IMAGE_NAME:$BRANCH.${1,,}build
    popd
  fi
}

build_and_push_main() {
  if [ -f $1 ]; then
    echo "*THIS IS A FILE***********************************************"
    #${1,,} will convert folder name to lowercase
    docker build -t $IMAGE_NAME:$BRANCH .
    docker commit $SHIPPABLE_CONTAINER_NAME $IMAGE_NAME:$BRANCH
    docker push $IMAGE_NAME:$BRANCH
    popd
  fi
}

if [ "$IS_PULL_REQUEST" != true ]; then
  detect_changed_files_and_folders
else
  echo "skipping because it's not a PR"
fi
