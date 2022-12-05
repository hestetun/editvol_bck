#!/bin/bash   

## Common variables
SPEED=450000
LOGDIR=/Users/ole/scripts/logs
TODAY="$(date '+%y%m%d_%H%M')"
STODAY="$(date '+%y%m%d')"
LOGF=$LOGDIR/edit_vol_bck_$TODAY.log

## Script it baby!

echo "Backup started on $HOSTNAME on $TODAY" >> $LOGF
echo "" >> $LOGF

echo "" >> $LOGF
echo "List of volumes to be backed up" >> $LOGF
cat /Users/ole/scripts/edit_vol_list.txt >> $LOGF
echo "" >> $LOGF

# TO DO, remove rsync and just use zip.

## The actual backup
VOLS=`cat /Users/ole/scripts/edit_vol_list.txt` #List of volumes to back up from edit_vol_list.txt
for VOL in $VOLS; do
   echo "" >> $LOGF
   echo "rsync backup of $VOL starts now..." >> $LOGF
   mkdir -p /Volumes/temp/scn_backup/$VOL
   rsync -rltvhq --stats --bwlimit=$SPEED --exclude-from=/Users/ole/scripts/edit_rsync_exclude /Volumes/$VOL/editorial/project /Volumes/temp/scn_backup/$VOL/$STODAY >> $LOGF
   echo "" >> $LOGF
   pushd /Volumes/temp/scn_backup/
   chmod -R 777 .
   zip -qrmDT $VOL/"$STODAY"_"$VOL" $VOL/$STODAY >> $LOGF
   rm -r $VOL/$STODAY
   echo "" >> $LOGF
   sync

done
# zip paramenters rmqoD
#zip -qrTmD -1 $VOL/"$STODAY"_"$VOL" $VOL/$STODAY >> $LOGF

## Some sexy reports
 echo "Size of backups" >> $LOGF
   du -shc /Volumes/temp/scn_backup/* | sort -n >> $LOGF
   echo "" >> $LOGF
   echo "Size of volumes" >> $LOGF
   df -h | grep _edit >> $LOGF

echo "" >> $LOGF
echo "Backup is done... " >> $LOGF
cat $LOGF

## Sending log to email recipients
/opt/homebrew/bin/mutt -s "Backup $TODAY - log for edit disks" ole@shortcutoslo.no < $LOGF
