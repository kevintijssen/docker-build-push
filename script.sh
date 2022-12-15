#!/bin/bash

command='buildAndPush'
name='nginx'
registry='registry.kevintijssen.eu'
tags='latest'
dockerfile='.'

case ${command} in
    (build|push|buildAndPush) ;;
    (*) echo "ERROR: invalid variable '${command}' for 'command'. Allowed variables are 'build, push, buildAndPush'";
    exit 1;;
esac



function build() {
  for tag in $(echo $tags | sed 's/,/ /g'); do

    # Generate complete dockerTag
    if [[ -z ${registry} ]]; then
      dockerTag="${name}:${tag}"
    else
      dockerTag="${registry}/${name}:${tag}"
    fi

    # Run Docker build
    docker build -t $dockerTag $dockerfile
  done
}

function push() {
  for tag in $(echo $tags | sed 's/,/ /g'); do

    # Generate complete dockerTag
    if [[ -z ${registry} ]]; then
      dockerTag="${name}:${tag}"
    else
      dockerTag="${registry}/${name}:${tag}"
    fi

    # Run Docker push
    docker push $dockerTag -q
  done
}




if [[ $command == "build" ]]; then
  build
  exit 0
elif [[ $command == "push" ]]; then
  push
  exit 0
else
  build
  push
  exit 0
fi