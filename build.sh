#!/bin/bash

VERSION=16
TAG=$(date +%F)
MYHUBID=dataeditors
MYIMG=stata${VERSION}

DOCKER_BUILDKIT=1 docker build  . \
  -t $MYHUBID/${MYIMG}:$TAG
