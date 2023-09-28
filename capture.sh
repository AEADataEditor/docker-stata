#!/bin/bash

# this script captures an existing Stata install, updated as necessary

# set locations
[[ -z $1 ]] && VERSION=17 || VERSION=$1
TARLOC=bin-exclude
TARBASE=$(pwd)/bin-exclude/stata-installed-$VERSION
TARFILE=${TARBASE}.tgz
VTARFILE=${TARBASE}.$(date +%F).tgz
TMP=/mnt/local/fast_home/$USER/tmp
BUILD=$TMP/stata-build
INSTALLED=usr/local/stata$VERSION

# untar

printf "%20s " "Prepare build."
[[ -d $BUILD ]] && \rm -rf $BUILD
mkdir -p $BUILD
cd $BUILD
if [[ -f $TARFILE ]]
then
	tar xzf $TARFILE && echo "Tar file unpacked." || exit 2
	\rm -rf $BUILD/$INSTALLED/utilities/.old
	[[ "$VERSION" == "17" || "$VERSION" == 18 ]] && \rm -rf $BUILD/$INSTALLED/utilities/java/linux-x64
	printf "%20s " ""
	echo "Ready for sync."
else
	echo "No previous version found"
	mkdir -p $BUILD/$INSTALLED
fi
echo "  $BUILD"

# Figure out the latest java VERSION


# sync

printf "%20s " "Syncing."
rsync -au --exclude='.old' /$INSTALLED/ $BUILD/$INSTALLED/ && echo "Done." || exit 2

# remove license

printf "%20s " "Remove license:"
#LICFILE=$BUILD/$INSTALLED/stata.lic
find $BUILD/$INSTALLED -name stata.lic\* -exec rm {} \;

# Pack it back up

printf "%20s " "Rebuild tarfile:"
cd $BUILD
tar czf $VTARFILE $INSTALLED && echo "Done."

printf "%20s " "Replace tarfile?"
\cp -i $VTARFILE $TARFILE
echo "All done."



