#!/usr/bin/bash

#email info
FROM='Envi\ System\<alex@gmail.com\>'
TO='alex@yandex.ru'

#db connect                                                                                
DBNAME='DB_NAME'
NOW=$(date +%d.%m.%Y)
FULLNAME=db\_$DBNAME\_$NOW.sql
USER='test'
PASSWD='test'

#select

NUMBER="32"
STRING="Its a var"
TEXT="<i>Новых заметок: </i> <br>
 <i>Всего заметок: </i> <br>
 <i>Попыток входа на сайт: </i> <br>
 <b>Бэк ап во вложении</b>"


mysqldump -u $USER -p$PASSWD $DBNAME > ./$FULLNAME 2>/dev/null
zip $FULLNAME.zip $FULLNAME && \
echo $TEXT | mutt -e "set content_type=text/html" -s "Report for $NOW" $TO  -a ./$FULLNAME.zip && \
echo $FULLNAME
rm $FULLNAME && mv $FULLNAME.zip ./archive
