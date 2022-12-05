#!/bin/bash   

## Version 1.3.1

## Common variables
SPEED=450000
LOGDIR=/Users/ole/scripts/logs
TODAY="$(date '+%y%m%d_%H%M')"
STODAY="$(date '+%y%m%d')"
LOGF=$LOGDIR/edit_vol_bck_$TODAY.log
EMAIL_ADRESS=ole@shortcutoslo.no
EXCLUDE_LIST=/Users/ole/projects/git/scn-projectbackup/edit_rsync_exclude

## Script it baby!

echo "Backup started on $HOSTNAME on $TODAY" >> $LOGF
echo "" >> $LOGF

echo "" >> $LOGF
echo "List of volumes to be backed up" >> $LOGF
cat /Users/ole/scripts/edit_vol_list.txt >> $LOGF
echo "" >> $LOGF

## Create destination folder
mkdir -p /Volumes/temp/scn_backup/$VOL

## The actual backup
VOLS=`cat /Users/ole/projects/git/scn_editvol_bck/edit_vol_list.txt` #List of volumes to back up from edit_vol_list.txt
for VOL in $VOLS; do
	echo "" >> $LOGF
	echo "backup of $VOL starts now..." >> $LOGF
	
	# Create destination folder 
	mkdir -p /Volumes/temp/scn_backup/$VOL
	
	# Sync it off Facilis
	rsync -ahq --progress --stats --exclude-from=$EXCLUDE_LIST --bwlimit=$SPEED /Volumes/$VOL/editorial/project /Volumes/temp/scn_backup/$VOL/$STODAY  >> $LOGF 

	# Make a zipped backup
	pushd /Volumes/temp/scn_backup/$VOL   
	zip -r -q -T -m -9 "$STODAY"_"$VOL".zip $STODAY >> $LOGF
	popd

	echo "" >> $LOGF

done

## Explination of the syntax

# zip -r -q -T -m

# -r: Recursively traverse any subdirectories (including compressed archives) and add the contents of those directories to the ZIP archive.

# -q: Quiet mode. Suppress any output messages.

# -T: Test the integrity of the compressed files.

# -m: Move files into the ZIP archive instead of copying them. This will delete the original files after they have been added to the archive.



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
/opt/homebrew/bin/mutt -s "Backup $TODAY - log for edit disks" $EMAIL_ADRESS < $LOGF
