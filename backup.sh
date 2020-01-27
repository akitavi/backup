#!/bin/bash

#MYSQLDUMP simple script


DBNAME='home'
NOW=$(date +%d%m%y)
NOW_FULL=$(date "+%d-%m-%y %T")
FULLNAME="$DBNAME-$NOW.sql"
ARCHNAME="$DBNAME-$NOW"
BKP_DIR="/root/backups"
LOG="/mnt/db_backup/logs/backup_db_$DBNAME.log"
FINDIR="/mnt/db_backup"

#удобненькая функция
echolog() {
	echo "$1" >> $LOG
}


echolog "#### START BACKUP $NOW_FULL ####" 
#Test connect MYSQL
mysql -e "quit" 2>/dev/null
test_con=$?

if [[ $test_con != 0 ]]; then
	echolog "Mysql connect: FAILED!" 
	echolog "Exit" 
else
	echolog "Mysql connect: SUCCESS!"
	echolog "Start full mysqldump on DB: $DBNAME" 
#Выгрузка и архивация базы
	mysqldump $DBNAME > "$FULLNAME" 2>/dev/null
		if [[ -s  $FULLNAME ]]; then
		echolog "Mysqldump created: SUCCESS!" 
		tar -czf "$BKP_DIR/$ARCHNAME.gz" "$FULLNAME" 2> /dev/null
			if [[ -s  $BKP_DIR/$ARCHNAME.gz ]]; then
#Архивация 
				echolog "Archive created: SUCCESS!" 
				ARCH_SIZE=$(du -h $BKP_DIR/"$ARCHNAME".gz | cut -f1)
				echolog "Archive size: $ARCH_SIZE" 
			else
				echolog "Archive created: FAILED!" 
			fi
		else
		echolog "Mysqldump created: FAILED!" 
	fi
echolog "Deleted tmp file..." 
rm "$FULLNAME"
rsync $BKP_DIR/"$ARCHNAME".gz $FINDIR

fi
echolog "#########  FINISH  ##########" 
echolog "|----------------------------|"  
exit