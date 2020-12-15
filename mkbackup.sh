#!/bin/bash
ROOTPWD=/root/backups

. $ROOTPWD/mkbackup.dat
if [[ $? != 0 ]]; then exit 1; fi

if [ ! -d $LOGDIR ] ; then
  mkdir -p -m 775 $LOGDIR
  if [[ $? != 0 ]] ; then
    exit 1;
  fi
  chown root:root $LOGDIR
fi

if [ ! -d $BACKUPDIR ] ; then
  mkdir -p -m 775 $BACKUPDIR
  if [[ $? != 0 ]] ; then
    exit 1;
  fi
  chown root:root $BACKUPDIR
fi

echo "[$(date)] Start remove old backups." >> $LOGFILE
allbackups=$(ls $BACKUPDIR | sort -V)
oldbackups=$(echo "$allbackups" | head -n -$MAXBACKUPS)
for old in $oldbackups; do
  rm -rf $BACKUPDIR/$old
  echo "[$(date)] Remove $old. Code - $?" >> $LOGFILE
done
echo "[$(date)] Done." >> $LOGFILE

tempdir=`mktemp -d`
cd $tempdir
echo "[$(date)] Starting backup." >> $LOGFILE
for ((i = 0; i < ${#BKP[@]}; i+=1)); do
  tar -czf ${BKP[i]}.tar.gz ${BKP[i]} >> $LOGFILE 2>&1
  echo "[$(date)] Backup ${BKP[i]} conf. Code - $?" >> $LOGFILE 2>&1
done
tar -czf "$BACKUPDIR/backup-$(date --rfc-3339=date).tar.gz" $tempdir >> $LOGFILE 2>&1
echo "[$(date)] Move backup into $BACKUPDIR/. Code - $?" >> $LOGFILE 2>&1
rm -rf $tempdir
echo "[$(date)] Complete backup. Remove temporary files. Code - $?" >> $LOGFILE 2>&1

if [ -f $ROOTPWD/mkbackup.extra.sh ] ; then
  $ROOTPWD/mkbackup.extra.sh
fi
