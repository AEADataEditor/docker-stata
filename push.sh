#!/bin/bash

if [[ -z $1 || "$1" == "-h" ]]
then
cat << EOF

$0 -v[ersion] -t[ag] 

where 
  - Version: of Stata (17, 18, ...) (can be omitted if set in _version.sh)
  - Tag: tag to give Docker image (typically date)
  - h: this helpfile
EOF
exit 2
fi

source ./_version.sh
while getopts v:t:c: flag
do
    case "${flag}" in
        v) VERSION=${OPTARG};;
        t) TAG=${OPTARG};;
    esac
done
VERSION=${VERSION:-18}
[[ -z $TAG ]] && TAG=$(date +%F) 
SHORTDESC="Docker image for Stata, to be used in automation and reproducibility."

MYHUBID=dataeditors
MYIMG=stata${VERSION}

# build all the images
# Base: 

echo "Ready to push? (y/N)"
echo "  docker push  $MYHUBID/${MYIMG}:$TAG"
echo " (will iterate across all images)"
docker images | grep $TAG | grep ${MYIMG}- 
read answer
case $answer in 
   y|Y)
   for arg in $(docker images | grep $TAG | grep ${MYIMG}- | awk ' { print $1 } ')
   do
	  docker push ${arg}:$TAG
	  # also push the README - requires installation of docker-pushrm https://github.com/christian-korneck/docker-pushrm
	  docker pushrm ${arg} --short "$SHORTDESC" 
   done
   ;;
   *)
   exit 0
   ;;
esac


