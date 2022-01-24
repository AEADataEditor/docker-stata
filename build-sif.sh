#!/bin/bash

VERSION=17
[[ -z $1 ]] && TAG=$(date +%F) || TAG=$1
MYHUBID=dataeditors
MYIMG=stata${VERSION}
SYLABSID=larsvilhuber

echo "======== Build SIF file for Stata $VERSION ========"
sudo singularity build stata${VERSION}.sif \
    docker-daemon://${MYHUBID}/${MYIMG}:${TAG}

[[ $? == 0 ]] || exit 2

echo "======== Sign SIF file for Stata $VERSION ========"
singularity sign stata${VERSION}.sif

echo "======== Push to Sylabs.io repository (under $MYHUBID ) ======="


echo "Ready to push?"
echo "  singularity push stata${VERSION}.sif  library://$SYLABSID/$MYHUBID/${MYIMG}:${TAG} "
read answer
case $answer in 
   y|Y)
singularity push stata${VERSION}.sif \
    library://$SYLABSID/$MYHUBID/${MYIMG}:${TAG}
    ;;
    *)
    exit 0
    ;;
esac
