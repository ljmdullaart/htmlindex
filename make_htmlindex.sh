#!/bin/bash
#INSTALL@ /usr/local/bin/make_htmlindex

COLS=3
TMP=/tmp/htmlindex.$$.$RANDOM

output(){
	if [ -d www ] ; then
		echo $* >> www/htmlindex.html
	fi
	if [ -d html ] ; then
		echo $* >> html/htmlindex.htm
	fi
}

#                                 _     _      
#  _ __  _ __ ___  __ _ _ __ ___ | |__ | | ___ 
# | '_ \| '__/ _ \/ _` | '_ ` _ \| '_ \| |/ _ \
# | |_) | | |  __/ (_| | | | | | | |_) | |  __/
# | .__/|_|  \___|\__,_|_| |_| |_|_.__/|_|\___|
# |_|                                          


if [ -d www ] ; then
cat > www/htmlindex.html << EOF
<!DOCTYPE HTML>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
EOF
if [ -f stylesheet.css ] ; then
	echo "<LINK HREF=\"stylesheet.css\" REL=\"stylesheet\" TYPE=\"text/css\">" >> www/htmlindex.html
fi
cat >> www/htmlindex.html << EOF
<title>Untitled</title>
</head>
<body>
<div class=header>
EOF
cat photoheader >> www/htmlindex.html
cat >> www/htmlindex.html << EOF
</div>
<p>
EOF
fi

#                              _                            _ _     _   
#  _ __   __ _ _ __ ___  ___  (_)_ __ ___   __ _  __ _  ___| (_)___| |_ 
# | '_ \ / _` | '__/ __|/ _ \ | | '_ ` _ \ / _` |/ _` |/ _ \ | / __| __|
# | |_) | (_| | |  \__ \  __/ | | | | | | | (_| | (_| |  __/ | \__ \ |_ 
# | .__/ \__,_|_|  |___/\___| |_|_| |_| |_|\__,_|\__, |\___|_|_|___/\__|
# |_|                                            |___/    

output '<table class="phototable">'
prev=none

col=0
for f in images/thumb/* ; do
	b=$(basename $f)
	display -geometry +10+10 images/medium/$b &
	tokill=$!
	sleep 0.1
	if [ $prev != none ] ; then
		kill $prev
	fi
	if [ $col = 0 ] ; then
		output '    <tr class="photorow">'
	fi
	output "        <td class=\"photocell\"><a href=\"images/fullsize/$b\"><img src=\"$f\"></a></td>"
	col=$((col+1))
	if [ $col = $COLS ] ; then
		col=0
		output "    </tr>"
	fi
	sleep 0.3
	prev=$tokill
done

if [ $prev != none ] ; then
	kill $prev
fi
if [ $col != 0 ] ; then
	output "    </tr>"
fi

output '</table>'

cp  www/htmlindex.html .

rm -rf $TMP
