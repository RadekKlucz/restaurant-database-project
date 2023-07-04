# Project Description - Restaurant Management System
## :keyboard:	About source code
The project involves the development of a restaurant management system to support the operations of a food service company catering to individual customers and businesses. The system aims to streamline the process of ordering meals, managing table reservations, implementing discounts, and generating reports on orders and statistics.

### System Functions

1. Table Reservation:
   - Individual customers can reserve tables on-site while placing their orders.
   - Business customers can reserve tables for the company and/or specific employees.

2. Order Placement:
   - Customers can place orders for food and non-alcoholic beverages.
   - Orders can be fulfilled for dine-in or takeaway.
   - Advance orders can be submitted through an online form, allowing customers to select preferred pickup date and time.

3. Payment Handling:
   - Customers can make payments either before or after placing their orders.
   - A minimum order value may be required for pre-payment.

4. Menu Management:
   - The menu is determined at least one day in advance.
   - At least half of the menu items are changed every two weeks.
   - Pre-orders for seafood dishes are available on Thursdays, Fridays, and Saturdays, with a deadline on the preceding Monday due to individual import requirements.

5. Discounts:
   - The system supports discount programs for individual customers:
     - After completing a specific number of orders (e.g., Z1 = 10) with a minimum order amount (e.g., K1 = $30 per order), a discount of R1% (e.g., 3%) is applied to all orders.
     - After reaching a cumulative order value of K2 (e.g., $1000), a one-time discount of R2% (e.g., 5%) is applied to orders placed within D1 days (e.g., D1 = 7) from the day the discount is granted (discounts do not stack).

6. Reporting:
   - The system generates monthly and weekly reports on table reservations, discounts, menu items, and order statistics.
   - Customers can access reports specific to their own orders and discounts.

### Database Design

1. Database Design:
   - Designing the structure of the database to store information about customers, orders, table reservations, menus, discounts, etc.

2. Database Definition:
   - Defining tables and their fields, including data types and constraints.
   - Establishing primary and foreign keys to ensure data integrity.

3. Integrity Constraints:
   - Utilizing default values, value ranges, uniqueness constraints, and required fields.
   - Defining complex integrity rules as needed.

### Data Operations

1. Stored Procedures:
   - Defining stored procedures to handle data input and configuration changes within the system.
   - Creating functions that provide relevant quantitative information.

2. Triggers:
   - Employing triggers to maintain data consistency and fulfill specific customer requirements.

### View Structures

1. User Views:
   - Defining views that present the most relevant information to users, such as menus, table reservations, orders, discounts.
   - Creating views for various types of reports.

### Indexing

1. Index Design:
   - Proposing and defining indexes to improve data retrieval and query performance.

### Data Access Permissions

1. Roles and Permissions:
   - Planning user roles and their permissions for operations, views, and procedures within the system.
   - Assigning appropriate permissions based on user roles.

## 🧑‍💻 Technology stack

* T-SQL
* SQL Server
* Docker

## 🎆 How to run project

1. Clone the repository to your computer,
2. Go to the main folder in the repository,
3. Using docker evaluate the following command in the console:
    ```docker
    docker compose up -d --build
    ```
4. Using SQL Server login into the database with credentials:
  ```text
  username: SA
  password: password123!
  ``` 
5. Import the main.sql file into SQL Server and run the script.

## 🌠 Features

## 📁 Directory Structure

    ├───main
        └───database
        │   └───data
        │   └───queries
        │       └───database
        │       └───tables
        │       └───views
        │       └───procedures
        │       └───functions
        │       └───triggers
        │       └───indexes
        │       └───roles
        └───app

## 📧 Contact

[![LinkedIn](https://i.stack.imgur.com/gVE0j.png) Radosław Kluczewski](https:///www.linkedin.com/in/radoslaw-kluczewski) 
&nbsp;
[![GitHub](https://i.stack.imgur.com/tskMh.png) RadekKlucz](https://github.com/RadekKlucz)

## License

[![Licence](https://img.shields.io/github/license/Ileriayo/markdown-badges?style=for-the-badge)](./LICENSE)