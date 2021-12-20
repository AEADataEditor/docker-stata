#!/bin/bash

VERSION=17
[[ -z $1 ]] && TAG=$(date +%F) || TAG=$1
MYHUBID=dataeditors
MYIMG=stata${VERSION}

DOCKER_BUILDKIT=1 docker build  . \
  -t $MYHUBID/${MYIMG}:$TAG
