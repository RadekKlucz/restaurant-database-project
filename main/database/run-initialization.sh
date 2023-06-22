sleep 5s 
/opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/database-and-tables.sql
sleep 5s
/opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/views.sql
sleep 5s 
/opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/insert-data.sql
sleep 5s
/opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/procedures.sql 