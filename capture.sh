#!/bin/bash

# this script captures an existing Stata install, updated as necessary

# set locations

source ./_version.sh

[[ -z $1 ]] || VERSION=$1
TARLOC=bin-exclude
TARBASE=$(pwd)/bin-exclude/stata-installed-$VERSION
TARFILE=${TARBASE}.tgz
VTARFILE=${TARBASE}-$(date +%F)
TMP=/mnt/local/fast_home/$USER/tmp
BUILD=$TMP/stata-build
INSTALLED=usr/local/stata${VERSION%%_*}

# untar

printf "%20s " "Prepare build."
[[ -d $BUILD ]] && \rm -rf $BUILD
mkdir -p $BUILD
cd $BUILD
if [[ -f $TARFILE ]]
then
	tar xzf $TARFILE && echo "Tar file unpacked." || exit 2
	\rm -rf $BUILD/$INSTALLED/utilities/.old
	[[ "$VERSION" == "17" || "$VERSION" == "18" || "$VERSION" == "18_5" ]] && \rm -rf $BUILD/$INSTALLED/utilities/java/linux-x64
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
echo "Done."

# Pack it back up

printf "%20s \n" "Rebuild tarfile:"
cd $BUILD
printf "%20s - " "Docs"
tar czf ${VTARFILE}-docs.tgz $INSTALLED/docs \
	&& \rm -rf $INSTALLED/docs || exit 2
echo "Done"
printf "%20s - " "Help files"
tar czf ${VTARFILE}-help.tgz $(find $INSTALLED -name \*hlp) \
	&& find $INSTALLED -name \*hlp -exec rm {} \; || exit 2
echo "Done"
for arg in mp se be
do
   printf "%20s - " "Stata $arg" 
   case $arg in 
	   be)
		   type=
		   ;;
	   *)
		   type=-$arg
		   ;;
   esac
   tar czf ${VTARFILE}-${arg}.tgz $INSTALLED/libstata${type}.* $INSTALLED/stata${type} 
   echo "Done"
   printf "%20s - " "Stata X $arg"
   tar czf ${VTARFILE}-x${arg}.tgz $INSTALLED/xstata${type} $INSTALLED/libstata${type}.*  $INSTALLED/stata_pdf 
   echo "Done"
done

printf "%20s - " "Deleting excess files" 
\rm -rf $INSTALLED/libstata${arg}* $INSTALLED/stata-*  || exit 2
\rm -rf $INSTALLED/libstata* $INSTALLED/stata || exit 2
\rm -rf $INSTALLED/x* $INSTALLED/stata_pdf|| exit 2
echo "Done"

printf "%20s - " "Stata base - whats left"
tar czf ${VTARFILE}-base.tgz $INSTALLED && echo "Done."

echo "All done."



