sleep 10s
/opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/database/database.sql
sleep 5s
/opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/tables/tables.sql
sleep 5s
/opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/views/views.sql
sleep 5s
/opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/procedures/procedures.sql
sleep 5s 
/opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/functions/functions.sql
sleep 5s 
/opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/triggers/triggers.sql
sleep 5s 
/opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/indexes/indexes.sql
sleep 5s 
# /opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/roles/roles.sql
sleep 5s 
# /opt/mssql-tools/bin/sqlcmd -S $HOST -U $USERNAME -P $SA_PASSWORD -d master -i ./queries/insert-data.sql