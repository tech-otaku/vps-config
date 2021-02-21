#!/bin/bash

#IGNORE=("N/A")

while IFS="" read -r database || [ -n "$database" ]; do
    MYSQLUSER=$(echo "$database" | cut -d';' -f1)
    DB=$(echo "$database" | cut -d';' -f2)
    
    if [[ ! "$MYSQLUSER" =~ ^# ]]; then
        
#    if [[ ! " ${IGNORE[@]} " =~ " ${DB} " ]]; then
    
        if [[ -n $(find /home/steve/tmp/ -name "$DB"_*.sql) ]]; then
    
            printf "Processing file '%s' for '%s'\n" $(ls -t /home/steve/tmp/"$DB"_*.sql | head -n +1) $DB
            
            echo "SET FOREIGN_KEY_CHECKS = 0;" > ./drop-tables.sql
            mysqldump --defaults-group-suffix=-$DB --add-drop-table --no-data -u $MYSQLUSER $DB | grep 'DROP TABLE' >> ./drop-tables.sql
            echo "SET FOREIGN_KEY_CHECKS = 1;" >> ./drop-tables.sql
            mysql --defaults-group-suffix=-$DB -u $MYSQLUSER $DB < ./drop-tables.sql
            mysql --defaults-group-suffix=-$DB -u $MYSQLUSER $DB < $(ls -t /home/steve/tmp/"$DB"_*.sql | head -n +1)
        
        fi
        
    else
        
        printf "     Ignoring '%s'\n" $DB
        
    fi

done < ./databases.migrate
