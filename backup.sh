#!/usr/bin/bash

#MYSQLDUMP simple script


DBNAME='home'
NOW=$(date +%d%m%y)
NOW_FULL=$(date "+%d-%m-%y %T")
FULLNAME="$DBNAME-$NOW.sql"
ARCHNAME="$DBNAME-$NOW"
BKP_DIR="/home/akit/Code/backup_sh/backups"
FINDIR="/mnt/db_backup"
LOG="$FINDIR/logs/backup_db_$DBNAME.log"

#send proccess log to logfile
echolog() {
	echo "$1" >> $LOG
}


echolog "#### $NOW_FULL START BACKUP ####" 
#Test connect MYSQL

if ! mysql -e "quit" 2>/dev/null; then
	echolog "Mysql connect: FAILED!"
else
	echolog "Mysql connect: SUCCESS!"
	echolog "Mysqldump start on: $DBNAME" 
#MYSQLDUMP
	mysqldump $DBNAME > "$FULLNAME" 2>/dev/null
	if ! mysqldump $DBNAME > "$FULLNAME" 2>/dev/null; then
		echolog "Mysqldump created: FAILED!"
		echolog "#########  FINISH  ##########" 
		echolog "|----------------------------|" 
		exit 1
	else
		echolog "Mysqldump created: SUCCESS!" 
		tar -czf "$BKP_DIR/$ARCHNAME.gz" "$FULLNAME" 2> /dev/null
		if [[ -s  $BKP_DIR/$ARCHNAME.gz ]]; then
			ARCHNAME="$ARCHNAME.gz"
			echolog "Archive created: SUCCESS!" 
			ARCH_SIZE=$(du -h $BKP_DIR/"$ARCHNAME" | cut -f1)
			echolog "Archive size: $ARCH_SIZE" 
		fi
	fi

	echolog "Start copy backup to archive place"
#COPY TO ARCHIVE SERVER
	rsync $BKP_DIR/"$ARCHNAME" $FINDIR
	if [[ -s $FINDIR/$ARCHNAME ]]; then
		echolog "Copy file to archive: SUCCESS"
	else
		echolog "Copy to archive: FAILED"
	fi

	echolog "Deleted tmp file..." 
	rm "$FULLNAME"
	
fi
echolog "|----------------------------|"  
exit