#!/bin/bash

if [[ -z $1 ]] 
then
	echo "provide version number"
	exit 2
fi

VERSION=$1
TAG=2021-12-08
MYHUBID=dataeditors
MYIMG=stata${VERSION}
STATALIC=$(find $HOME/Dropbox/ -name stata.lic.$VERSION | tail -1)
docker run -it --rm \
  -v ${STATALIC}:/usr/local/stata/stata.lic \
  -v $(pwd)/code:/code \
  -v $(pwd)/data:/data \
  $MYHUBID/${MYIMG}:${TAG}

