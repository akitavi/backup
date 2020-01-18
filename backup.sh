#/usr/bin/bash

#Параметры подключения, остальные данные для подключения в файле ~/.my.cnf
DBNAME='home'


#
NOW=$(date +%d%m%y)
NOW_FULL=$(date "+%d-%m-%y %T")
FULLNAME="$DBNAME-$NOW.sql"
ARCHNAME="$DBNAME-$NOW"
BKP_DIR="/home/akit/Code/backup_sh/backups"
LOG="./$ARCHNAME.log"


echo "#### START BACKUP $NOW_FULL ####" >> $LOG

#Test connect MYSQL
mysql -e "quit" 2>/dev/null
test_con=$?

if [[ $test_con != 0 ]]; then
	echo "ERROR: Mysql connect test FAILED!" >> $LOG
	echo "Exit" >> $LOG
	else
	echo "Mysql connect: SUCCESS!" >> $LOG
	echo "Start mysqldump on DB: $DBNAME" >> $LOG
	#Выгрузка и архивация базы
	mysqldump $DBNAME > ./$FULLNAME 2>/dev/null
		if [[ -s  ./$FULLNAME ]]; then
		echo "Mysqldump created: SUCCESS!" >> $LOG
		tar -czf "$BKP_DIR/$ARCHNAME.gz" $FULLNAME 2> /dev/null
			if [[ -s  $BKP_DIR/$ARCHNAME.gz ]]; then
				echo "Archive created: SUCCESS!" >> $LOG
				ARCH_SIZE=$(du -h $BKP_DIR/$ARCHNAME.gz | cut -f1)
				echo "Archive size: $ARCH_SIZE" >> $LOG
			else
				echo "ERROR: archive FAILED!" >> $LOG
			fi
		else
		echo "ERROR: mysqdump FAILED!" >> $LOG
	fi
echo "Deleted tmp file..." >> $LOG
rm $FULLNAME

fi
echo "#########  FINISH  ##########"  >> $LOG
echo "|----------------------------|"  >> $LOG
exit
