#!/bin/bash

[[ -z $VERSION ]] && VERSION=18
[[ -z $1 ]] && TAG=$(date +%F) || TAG=$1
MYHUBID=dataeditors
MYIMG=stata${VERSION}

DOCKER_BUILDKIT=1 docker build --build-arg VERSION=$VERSION . \
  -t $MYHUBID/${MYIMG}:$TAG

echo "Ready to push?"
echo "  docker push  $MYHUBID/${MYIMG}:$TAG"
read answer
case $answer in 
   y|Y)
   docker push  $MYHUBID/${MYIMG}:$TAG
   ;;
   *)
   exit 0
   ;;
esac

echo "Pushing any updates to the Docker Hub README"
docker pushrm $MYHUBID/${MYIMG}

