#!/bin/bash
# ninja semlegesito script v.0.1
# ha ninja attack alatt allunk, akkor a tuzfal connlimit szabalyat modositja
# ha vege a tamadasnak, akkor a connlimit szabalyt viszallitja
# a szabaly amit modositunk a kapcsolatok szamanak fuggvenyeben:
# iptables -A INPUT -p TCP --dport 80 -m connlimit --connlimit-above 3 -j REJECT --reject-with tcp-reset
# sumo
set -e

DATE=`date +%F\ %T`
CONUMBER=`netstat -tan | grep ":80 " | wc -l`
FWALL="/usr/local/sbin/firewall_start.sh"
TMPFILE="/tmp/out.tmp.$$"
LOG="/home/sumo/attack/ninjalog.log"

#ninja attack alatt
if [ "$CONUMBER" > 100 ]; then
	sed 's/--connlimit-above\ 10/--connlimit-above\ 3/g' $FWALL > $TMPFILE && mv $TMPFILE $FWALL
	echo "\n connlimit 3-ra csokkentve \n Datum: $DATE \n" >> $LOG
	exit
fi

#ha a ninja attack elmult
if [ "$CONUMBER" < 100 ]; then
	sed 's/--connlimit-above\ 3/--connlimit-above\ 10/g' $FWALL > $TMPFILE && mv $TMPFILE $FWALL
	echo "\n connlimit 10-re novelve \n Datum: $DATE \n" >> $LOG
	exit
fi

#EOF