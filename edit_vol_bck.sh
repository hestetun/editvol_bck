#!/bin/bash   

## Version 1.4.1

## Common variables
LOGDIR=/Users/ole/scripts/logs
LOGF=$LOGDIR/edit_vol_bck_$TODAY.log
TODAY="$(date '+%y%m%d_%H%M')"
STODAY="$(date '+%y%m%d')"
EXCLUDE_LIST=/Users/ole/projects/git/scn_editvol_bck/edit_rsync_exclude.txt
EMAIL_ADRESS=ole@shortcutoslo.no
DEST=/Volumes/temp/scn_backup

## Script it baby!

echo "Backup started on $HOSTNAME on $TODAY" >> $LOGF
echo "" >> $LOGF

echo "" >> $LOGF
echo "List of volumes to be backed up" >> $LOGF
eval "$VOL" >> $LOGF #List
echo "" >> $LOGF

## Create destination folder
mkdir -p $DEST/$VOL

## The actual backup
VOLS=`mount | grep "_edit" | awk '{print substr($3, 10)}'` #List of volumes to back up from edit_vol_list.txt
for VOL in $VOLS; do
	echo "" >> $LOGF
	echo "backup of $VOL starts now..." >> $LOGF

	# Create destination folder 
	mkdir -p $DEST/$VOL

	# tar it off Facilis
	tar --exclude="*.lck" --exclude="*.prlock" --exclude="*.pat" --exclude="*.awf" --exclude="*.zip" --exclude="*.mp4" --exclude="*.mov" --exclude="*.wav" --exclude="*.cfa" --exclude="*/SearchData/" --exclude="*/WaveformCache/"  -czvf $DEST/$VOL/$STODAY"_"$VOL.tar -C "/Volumes/$VOL/editorial/project/" . >> $LOGF

	echo "" >> $LOGF

done

## Some sexy reports
 echo "Size of backups" >> $LOGF
   du -shc $DEST/* | sort -n >> $LOGF
   echo "" >> $LOGF
   echo "Size of volumes" >> $LOGF
   df -h | grep _edit >> $LOGF

echo "" >> $LOGF
echo "Backup is done... " >> $LOGF
cat $LOGF

## Sending log to email recipients
/opt/homebrew/bin/mutt -s "Backup $TODAY - log for edit disks" $EMAIL_ADRESS < $LOGF
