#!/bin/bash

VERSION=17
[[ -z $1 ]] && TAG=$(date +%F) || TAG=$1
MYHUBID=dataeditors
MYIMG=stata${VERSION}
SYLABSID=vilhuberlars

echo "======== Build SIF file for Stata $VERSION ========"
sudo singularity build stata${VERSION}.sif \
    docker-daemon://${MYHUBID}/${MYIMG}:${TAG}

echo "======== Sign SIF file for Stata $VERSION ========"
singularity sign stata${VERSION}.sif

echo "======== Push to Sylabs.io repository (under $MYHUBID ) ======="
singularity push stata${VERSION}.sif \
    library://vilhuberlars/$MYHUBID/${MYIMG}:${TAG}
