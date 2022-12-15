#!/bin/bash

## Common variables
LOGDIR=/Users/ole/scripts/logs
TODAY="$(date '+%y%m%d_%H%M')"
STODAY="$(date '+%y%m%d')"
LOGF=$LOGDIR/edit_vol_attic_cln_$TODAY.log
EMAIL_ADRESS=ole@shortcutoslo.no
VOLS=`mount | grep "_edit" | awk '{print substr($3, 10)}'` #This list backs up all network disks with the name _edit
UNITYVOLS

echo "Cleaning started on $HOSTNAME on $TODAY" >> $LOGF
echo "" >> $LOGF

echo "" >> $LOGF
echo "List of volumes to be cleaned" >> $LOGF
echo "$VOLS" >> $LOGF #List
echo "" >> $LOGF

for VOL in $VOLS; do
    echo "" >> $LOGF
    echo "Cleaning out Attics of $VOL..." >> $LOGF

    # Zip it
    pushd /Volumes/$VOL/
    zip -r -q -T -m Unity\ Attic/"$TODAY"_"$VOL"_attic.zip Unity\ Attic/* -x "*.zip" >> $LOGF
    popd

done

## Some sexy reports
 echo "Size of backups" >> $LOGF
   du -sh /Volumes/$VOLS/Unity\ Attic | sort -h >> $LOGF
   echo "" >> $LOGF

    echo "" >> $LOGF
    echo "Cleaning is done... " >> $LOGF
    cat $LOGF

## Sending log to email recipients
/opt/homebrew/bin/mutt -s "Cleaning $TODAY - log for edit disks" $EMAIL_ADRESS < $LOGF
