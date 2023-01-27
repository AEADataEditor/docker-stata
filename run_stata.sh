#!/bin/bash

if [[ -z $1 ]] 
then
	echo "provide version number and tag"
	exit 2
fi

VERSION=$1
TAG=$2
[[ -z $TAG ]] && TAG=$(date +%Y-%m-%d)
MYHUBID=dataeditors
MYIMG=stata${VERSION}
# different versions of finding a Stata license file. Adjust as necessary.
STATALIC=$(pwd)/stata.lic.$VERSION
[[ -z $STATALIC ]] && STATALIC=$(find /usr/local/stata${VERSION} -name stata.lic | tail -1)
[[ -z $STATALIC ]] && STATALIC=$(find $HOME/Dropbox/ -name stata.lic.$VERSION | tail -1)
docker run -it --rm \
  -v ${STATALIC}:/usr/local/stata/stata.lic \
  -v $(pwd)/code:/code \
  -v $(pwd)/data:/data \
  $MYHUBID/${MYIMG}:${TAG}

