import psycopg2

connection = psycopg2.connect(
    host="localhost",
    database="restaurant",
    user='root',
    password='root'
)

with open(R'C:\Users\Radosław\Desktop\restaurant-database\main\database\queries\tables.sql') as f:
    create_tables = f.read()

# with open(R'C:\Users\Radosław\Desktop\restaurant-database\main\database\queries\fill_tables.sql') as f2:
#     fill_tables = f2.read()

with connection.cursor() as cur:
    cur.execute(create_tables)

# with connection.cursor() as cur2:
#     cur2.execute(fill_tables)

# with open(R'C:\Users\Radosław\Desktop\restaurant-database\main\database\queries\create_database.sql') as f3:
#     create_database = f3.read()

# with connection.cursor() as cur3:
#     cur3.execute(create_database)

connection.commit()
connection.close()