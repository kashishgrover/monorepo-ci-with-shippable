#!/bin/bash

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
    printf "*****%s IS A DIRECTORY*****" "$1"
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
    printf "*****%s IS A FILE IN THE ROOT DIRECTORY*****" "$1"
    #${1,,} will convert folder name to lowercase
    docker build -t $IMAGE_NAME:$BRANCH .
    docker commit $SHIPPABLE_CONTAINER_NAME $IMAGE_NAME:$BRANCH
    docker push $IMAGE_NAME:$BRANCH
  fi
}

if [ "$IS_PULL_REQUEST" != true ]; then
  detect_changed_files_and_folders
else
  echo "Skipping because it's a Pull Request"
fi
