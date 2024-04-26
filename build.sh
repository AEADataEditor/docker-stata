#!/bin/bash

if [[ -z $1 || "$1" == "-h" ]]
then
cat << EOF

$0 -v[ersion] -t[ag] -c[apture]

where 
  - Version: of Stata (17, 18, ...)
  - Tag: tag to give Docker image (typically date)
  - Capture: of the capture
  - h: this helpfile
EOF
exit 2
fi

while getopts v:t:c: flag
do
    case "${flag}" in
        v) VERSION=${OPTARG};;
        t) TAG=${OPTARG};;
        c) CAPTURE=${OPTARG};;
    esac
done
VERSION=${VERSION:-18}
[[ -z $TAG ]] && TAG=$(date +%F) 
[[ -z $CAPTURE ]] && $0 -h

cat << EOF

  VERSION: $VERSION
  TAG    : $TAG
  CAPTURE: $CAPTURE

Ready? 

EOF
read

MYHUBID=dataeditors
MYIMG=stata${VERSION}

# build all the images
# Base: 

image=base
DOCKER_BUILDKIT=1 docker build \
	-f Dockerfile.base \
	--build-arg VERSION=$VERSION  \
	--build-arg CAPTURE=$CAPTURE  \
	. \
        -t $MYHUBID/${MYIMG}-base:$TAG

# now build the functional command line versions

for arg in be se mp
do
	case $arg in 
		be)
			cmd=stata
			;;
	        *)
			cmd=stata-$arg
			;;
	esac
	sed "s+stata-mp+${cmd}+" Dockerfile.type > Dockerfile.$arg
	sed "s+stata-mp+x${cmd}+" Dockerfile.type > Dockerfile.x$arg

	# Build the command line versions
	DOCKER_BUILDKIT=1 docker build \
		-f Dockerfile.${arg} \
		--build-arg VERSION=${VERSION} \
	       	--build-arg TAG=${TAG} \
	      	--build-arg CAPTURE=${CAPTURE} \
	       	--build-arg TYPE=$arg \
		. \
                -t $MYHUBID/${MYIMG}-${arg}:$TAG
	# Build the interactive command line versions
	DOCKER_BUILDKIT=1 docker build \
		-f Dockerfile.${arg} \
		--build-arg VERSION=${VERSION} \
	       	--build-arg TAG=${TAG} \
	      	--build-arg CAPTURE=${CAPTURE} \
	       	--build-arg TYPE=help \
		--build-arg BASIS=$arg \
		. \
                -t $MYHUBID/${MYIMG}-${arg}-i:$TAG
	# build the X versions - note: still no X libraries
	DOCKER_BUILDKIT=1 docker build \
		-f Dockerfile.x${arg} \
		--build-arg VERSION=${VERSION} \
	       	--build-arg TAG=${TAG} \
	      	--build-arg CAPTURE=${CAPTURE} \
	       	--build-arg TYPE=x$arg \
		--build-arg BASIS=${arg}-i \
		. \
                -t $MYHUBID/${MYIMG}-${arg}-x:$TAG




done

exit 0
echo "Ready to push?"
echo "  docker push  $MYHUBID/${MYIMG}:$TAG"
echo " (will iterate across all images)"
read answer
case $answer in 
   y|Y)
   for arg $(docker images | grep $TAG | grep ${MYIMG}- | awk ' { print $1 } '))
   do
	  docker push ${arg}:$TAG
	  # also push the README - requires installation of docker-pushrm https://github.com/christian-korneck/docker-pushrm
	  docker pushrm ${arg}
   done
   ;;
   *)
   exit 0
   ;;
esac


