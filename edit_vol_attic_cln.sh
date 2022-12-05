#!/bin/bash

## Common variables
SPEED=450000
LOGDIR=/Users/ole/scripts/logs
TODAY="$(date '+%y%m%d_%H%M')"
STODAY="$(date '+%y%m%d')"
LOGF=$LOGDIR/edit_vol_attic_cln_$TODAY.log
EMAIL_ADRESS=ole@shortcutoslo.no


VOLS=`cat /Users/ole/projects/git/scn_editvol_bck/edit_vol_unity_list.txt` #List of volumes to back up from edit_vol_list.txt
for VOL in $VOLS; do
    echo "" >> $LOGF
    echo "Cleaning out Attics of $VOL..." >> $LOGF

    # Create zip backup directory
    mkdir -p /Volumes/$VOL/editorial/tmp/_unity-bak

    # Zip it
    pushd /Volumes/$VOL/Unity\ Attic
    zip -r -q -T -m -9 "$STODAY"_"$VOL".zip . >> $LOGF
    popd

    # Clean it out, moving it to a tmp-folder
    pushd /Volumes/$VOL/editorial/tmp/_unity-bak
    mv /Volumes/$VOL/Unity\ Attic/"$STODAY"_"$VOL".zip .
    popd

done
