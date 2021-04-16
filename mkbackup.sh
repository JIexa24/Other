#!/bin/bash
if [ -z $ROOTPWD ]; then
  export ROOTPWD=/usr/local/backups
fi

. $ROOTPWD/mkbackup.dat
if [[ $? != 0 ]]; then exit 1; fi

LOGFILE="$LOGDIR/mkbackup.log"
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
  f=`echo ${BKP[i]} | tr '/' ' '`
  f=($f)
  l=${#f[@]}
  tar -czf ${f[l-1]}.tar.gz ${BKP[i]} >> $LOGFILE 2>&1
  echo "[$(date)] Backup ${BKP[i]}. Code - $?" >> $LOGFILE 2>&1
done
tar -czf "$BACKUPDIR/backup-$(date --rfc-3339=date).tar.gz" $tempdir >> $LOGFILE 2>&1
echo "[$(date)] Move backup into $BACKUPDIR/. Code - $?" >> $LOGFILE 2>&1
cd
rm -rf $tempdir
echo "[$(date)] Complete backup. Remove temporary files. Code - $?" >> $LOGFILE 2>&1

if [ -f $ROOTPWD/mkbackup.extra.sh ] ; then
  $ROOTPWD/mkbackup.extra.sh
fi
