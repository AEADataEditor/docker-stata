#!/bin/bash

# this script captures an existing Stata install, updated as necessary

# set locations
version=17
TARLOC=bin-exclude
TARBASE=$(pwd)/bin-exclude/stata-installed-$version
TARFILE=${TARBASE}.tgz
VTARFILE=${TARBASE}.$(date +%F).tgz
TMP=/mnt/local/fast_home/$USER/tmp
BUILD=$TMP/stata-build
INSTALLED=usr/local/stata$version

# untar

printf "%20s " "Prepare build."
[[ -d $BUILD ]] && \rm -rf $BUILD
mkdir -p $BUILD
cd $BUILD
tar xzf $TARFILE && echo "Tar file unpacked." || exit 2
\rm -rf $BUILD/$INSTALLED/utilities/.old
printf "%20s " ""
echo "Ready for sync."
echo "  $BUILD"

# sync

printf "%20s " "Syncing."
rsync -au --exclude='.old' /$INSTALLED/ $BUILD/$INSTALLED/ && echo "Done." || exit 2

# remove license

printf "%20s " "Remove license:"
LICFILE=$BUILD/$INSTALLED/stata.lic
if [[ -f $LICFILE ]]
then
   rm -f $LICFILE && echo "Done."
else
   echo "None found."
fi

# Pack it back up

printf "%20s " "Rebuild tarfile:"
cd $BUILD
tar czf $VTARFILE $INSTALLED && echo "Done."

printf "%20s " "Replace tarfile?"
\cp -i $VTARFILE $TARFILE
echo "All done."



