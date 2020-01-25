#!/bin/bash
#INSTALL@ /usr/local/bin/configyour.htmlindex

THUMB=200x300
FULL=800x800
WD=`pwd`
BASE=`basename $WD`
LOG=configyour.log
echo "Configyour.htmlindex starting" >>$LOG
if [ -x /usr/local/bin/my_banner ] ; then
    banner=/usr/local/bin/my_banner
else
    banner=banner
fi

not_applicable(){
	$banner htmlindex n/a >> Makefile
	echo "No 'HTMLINDEX' in imagelist"
	echo "tag/upload.htmlindex: |tag" >> Makefile
	echo "	touch tag/upload.htmlindex" >> Makefile
	echo "tag/htmlindex: |tag" >> Makefile
	echo "	touch tag/htmlindex" >> Makefile
	echo "tag/clean.htmlindex: |tag" >> Makefile
	echo "	touch tag/clean.htmlindex" >> Makefile
	echo "Configyour.htmlindex finishing" >>$LOG
	exit 0
}


# Check if applicable
if [ ! -f imagelist ] ; then
	not_applicable
	echo "No imagelist found" >>$LOG
fi
if grep -q HTMLINDEX imagelist ; then
	$banner htmlindex >> Makefile
	echo "HTMLINDEX found in imagelist" >>$LOG
else
	not_applicable
fi

NOW=`date`

$banner htmlindex >> Makefile

echo "tag/htmlindex: html/htmlindex.htm |tag" >> Makefile
echo "	touch tag/htmlindex" >> Makefile
echo "html/htmlindex.htm: tag/photo /usr/local/bin/make_htmlindex photoheader" >> Makefile
echo "	make_htmlindex" >> Makefile

echo "tag/clean.htmlindex: |tag" >> Makefile
echo "	- rm -f htmlindex.html" >> Makefile
echo "	- rm -f www/htmlindex.html" >> Makefile
echo "	- rm -f html/htmlindex.htm" >> Makefile
echo "	- rm -rf tag/htmlindex.*" >> Makefile
echo "	touch tag/clean.htmlindex" >> Makefile
echo "Configyour.htmlindex finishing" >>$LOG
