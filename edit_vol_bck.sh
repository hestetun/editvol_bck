#!/bin/bash   

## Version 1.4.3

## Common variables
DEST=/Volumes/temp/_edit_backs
TODAY="$(date '+%y%m%d_%H%M')"
STODAY="$(date '+%y%m%d')"
LOGDIR=~/Library/Logs
LOGF=$LOGDIR/edit_vol_bck_$TODAY.log
EXCLUDE_LIST=/Users/systeminstaller/git/scn_editvol_bck/edit_exclude.txt
EMAIL_ADRESS=scntech@shortcutoslo.no
VOLS=`mount | grep "_edit" | awk '{print substr($3, 10)}'` #This list backs up all network disks with the name _edit

## Script it baby!

echo "Backup started on $HOSTNAME on $TODAY" >> $LOGF
echo "" >> $LOGF

# Delete staging copies
echo "Cleaning up staging area" >> $LOGF
rm -rfv $DEST/* >> $LOGF

echo "" >> $LOGF
echo "List of volumes to be backed up" >> $LOGF
echo "$VOLS" >> $LOGF #List
echo "" >> $LOGF

## Create destination folder
mkdir -p $DEST/$VOL

## The actual backup
for VOL in $VOLS; do
	echo "" >> $LOGF
	echo "backup of $VOL starts now $TODAY..." >> $LOGF

	# Create destination folder 
	mkdir -p $DEST/$VOL

	# tar it off Facilis
	tar --exclude-from $EXCLUDE_LIST -czvf $DEST/$VOL/$STODAY"_"$VOL.tar -C "/Volumes/$VOL/editorial/project/" . >> $LOGF

	echo "" >> $LOGF

done

## Some sexy reports
 echo "Size of backups" >> $LOGF
   du -sh $DEST/* | sort -h >> $LOGF
   echo "" >> $LOGF
   echo "Size of volumes" >> $LOGF
   df -h | grep _edit >> $LOGF

# Sync archives from staging to whiterabbit
rsync -rltvh --stats $DEST/* systeminstaller@scnfile02:/Volumes/whiterabbit/zz_scn_edit_bu/ >> $LOGF

echo "" >> $LOGF
echo "Backup is done... " >> $LOGF
cat $LOGF

## Sending log to email recipients
/opt/homebrew/bin/mutt -s "Backup $TODAY - log for edit disks" $EMAIL_ADRESS < $LOGF
