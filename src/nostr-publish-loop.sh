#!/bin/bash
# Configuration

RELAY="wss://nostr.mutinywallet.com"
RELAYBIS="wss://relay.nostr.band"
RELAYFALLBACK="wss://nostr-pub.wellordered.net"
PRIVKEY=$(cat ../config/NOSTR-HEX-PRIVKEY.txt)
POW=10



STATUS=$(cat ../data/STATUS.txt 2>/dev/null)
AIRPORT=$(cat ../data/AIRPORT.txt 2>/dev/null)
LASTAIRPORT=$(cat ../data/AIRPORT.txt 2>/dev/null)
MESSAGE=$(cat ../data/MESSAGE.txt 2>/dev/null)






echo "Waiting for status change to publish..."





while true
do
  NEW_STATUS=$(cat ../data/STATUS.txt)
  

  if [ "$STATUS" != "$NEW_STATUS" ]; then
    echo "=> Status changed! <="
    STATUS="$NEW_STATUS"
    

    if [ "$STATUS" == "Landed" ]; then
     echo "Landed..."
     echo "Getting position"
      node crawl-position.js
     echo "Converting position to airport name"
      python3 crawled-position-to-airport.py

     AIRPORT=$(cat ../data/AIRPORT.txt)
     LASTAIRPORT=$(cat ../data/AIRPORT.txt)
     echo " 🛬📍 Landed at "$AIRPORT" " > ../data/MESSAGE.txt
     MESSAGE=$(cat ../data/MESSAGE.txt)
     echo "$MESSAGE"
       echo "$a"
     nostril --envelope --pow "$POW" --sec "$PRIVKEY" --content "$MESSAGE" | tee >(websocat $RELAY) >(websocat $RELAYBIS) >(websocat $RELAYFALLBACK)  
        echo "$b"
     elif [ "$STATUS" == "Took Off" ]; then
     cp ../data/AIRPORT.txt ../data/LAST-AIRPORT.txt
     AIRPORT=$(cat ../data/AIRPORT.txt)
     echo " 🛫 Took Off from "$AIRPORT"." > ../data/MESSAGE.txt
     MESSAGE=$(cat ../data/MESSAGE.txt)
     echo "$MESSAGE"
     echo "$a"
     nostril --envelope --pow "$POW" --sec "$PRIVKEY" --content "$MESSAGE" | tee >(websocat $RELAY) >(websocat $RELAYBIS) >(websocat $RELAYFALLBACK)  
     echo "$b"

    elif [ "$STATUS" == "Parked" ]; then
      AIRPORT=$(cat ../data/AIRPORT.txt)
        echo "Parked"
   echo "$b"


    elif [ "$STATUS" == "Flying" ]; then
      echo "Flying :) "
    fi

  fi
  
  sleep 5
  
done
