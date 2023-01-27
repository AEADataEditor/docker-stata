#!/bin/bash

VERSION=15
TAG=$(date +%F)
if [[ ! -z $1 ]] 
then
	TAG=$1
fi
MYHUBID=dataeditors
MYIMG=stata${VERSION}

DOCKER_BUILDKIT=1 docker build \
   . \
  -t $MYHUBID/${MYIMG}:$TAG
