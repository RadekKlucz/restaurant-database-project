sleep 5s 
echo "Initializing database"
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -d master -i ./queries/database-and-tables.sql
sleep 5s 
# /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SA_PASSWORD -d master -i ./queries/tables.sql
sleep 5s 
