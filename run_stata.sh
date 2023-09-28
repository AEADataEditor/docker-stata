#!/bin/bash

if [[ -z $1 ]] 
then
	echo "provide date of snapshot"
	exit 2
fi

VERSION=${VERSION:-17}
TAG=${1:-2023-05-16}
shift
MYHUBID=dataeditors
MYIMG=stata${VERSION}
STATALIC=$(find $HOME/Dropbox/ -name stata.lic.$VERSION | tail -1)
docker run -it --rm \
  -v ${STATALIC}:/usr/local/stata/stata.lic \
  -v $(pwd)/code:/code \
  -v $(pwd)/data:/data \
  $MYHUBID/${MYIMG}:${TAG} "$@"

