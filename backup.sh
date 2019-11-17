#!/usr/bin/bash

#email info
FROM='Envi\ System\<groov6000@gmail.com\>'
TO='apalse@yandex.ru'

DBNAME='DB_NAME'
NOW=$(date +%d.%m.%Y)
FULLNAME=db\_$DBNAME\_$NOW.sql
USER='test'
PASSWD='test'
NUMBER="32"
STRING="Its a var"
TEXT="<i>Новых заметок: </i> <br>
 <i>Всего заметок: </i> <br>
 <i>Попыток входа на сайт: </i> <br>
 <b>Бэк ап во вложении</b>"


mysqldump -u $USER -p$PASSWD $DBNAME > ./$FULLNAME 2>/dev/null
zip $FULLNAME.zip $FULLNAME && \
echo $TEXT | mail -a 'Content-type: text/html; charset="UTF8"' -s "Report for $NOW" -aFrom:$FROM $TO  && \
rm $FULLNAME && mv $FULLNAME.zip ./archive