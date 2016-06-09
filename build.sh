#Put your image name over here
export IMAGE_NAME=kashishgrover/samplenodejstwoapps

#SHIPPABLE_COMMIT_RANGE is an Environment Variable which
#gives the range between the last successful Commit ID and
#the  current Commit ID as <COMMIT_ID_1>...<COMMIT_ID_2>

detect_changed_files_and_folders() {
  echo "Detecting Changes For This Build"
  languages=`git diff --name-only $SHIPPABLE_COMMIT_RANGE | sort -u | awk 'BEGIN {FS="/"} {print $1}' | uniq`
  for language in $languages
  do
    detect_changed_folders $language
  done
}

detect_changed_folders() {
  folders=`git diff --name-only $SHIPPABLE_COMMIT_RANGE | sort -u | grep $1 | awk 'BEGIN {FS="/"} {print $2}' | uniq`
  push_all_images=false
  for folder in $folders
  do
    if [ "$folder" == '_global' ]; then
      echo "pushing all images"
      push_all_images=true
      break
    fi
  done

  if [ "$push_all_images" == true ]; then
    cd $1
    export changed_components=`ls -d */ | sed 's/.$//'`
    cd ..
  else
    export changed_components=$folders
  fi
}

tag_and_push_changed_components() {
  for component in $changed_components
  do
    if [ "$component" != '_global' ] && [ "$component" != 'node_modules' ]; then
      tag_and_push_image $component
    fi
  done
}

tag_and_push_image() {
  if [[ -z "$1" ]]; then
    return 0
  else
    echo "tagging image $1"
    sudo docker tag -f $IMAGE_NAME:$BRANCH.$SHIPPABLE_BUILD_NUMBER $IMAGE_NAME:$1.$BRANCH.$SHIPPABLE_BUILD_NUMBER
    echo "pushing image $1"
    sudo docker push $IMAGE_NAME:$1.$BRANCH.$SHIPPABLE_BUILD_NUMBER
  fi
}


if [ "$IS_PULL_REQUEST" != true ]; then
  detect_changed_files_and_folders
  tag_and_push_changed_components
else
  echo "skipping because it's a PR"
fi
