#!/bin/bash

if [[ -z $1 ]] 
then
	echo "provide version number"
	exit 2
fi

VERSION=$1
TAG=2022-10-14
MYHUBID=dataeditors
MYIMG=stata${VERSION}
STATALIC=$(find $(pwd)/ -name stata.lic.$VERSION | tail -1)
[[ -z $STATALIC ]] && STATALIC=$(find $(pwd)/ -name stata.lic.17 | tail -1)
echo " Running $MYHUBID/${MYIMG}:${TAG}" 
docker run -it --rm \
  -v ${STATALIC}:/usr/local/stata/stata.lic \
  -v $(pwd)/code:/code \
  -v $(pwd)/data:/data \
  $MYHUBID/${MYIMG}:${TAG}

