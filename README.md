# E-commerce Database & Business Intelligence (BI) Platform
Designed and optimized a database for an e-commerce platform and developed a proof-of-concept business intelligence solution using Microsoft SQL Server Analysis Services (SSAS).

### Group Project - Database Design, Optimization, and BI Solution Development

This repository contains the project files and documentation for an e-commerce database and business intelligence platform. The goal of the project was to design, normalize, and optimize a database for an e-commerce platform and develop a proof-of-concept BI platform using Microsoft SQL Server Analysis Services (SSAS).

---

## Database Normalization and Optimization

### 1. Normalization to 3NF
We started by normalizing three initial tables to **Third Normal Form (3NF)** to reduce redundancy and improve data integrity:
- Removed partial dependencies and transitive dependencies.
- Ensured that all non-key attributes are fully functionally dependent on the primary key.

![DB Diagram](https://github.com/user-attachments/assets/48a7a934-d872-4b98-94bd-ee33d287c15d)


### 2. Creating Normalized Tables
After the normalization process, the newly designed tables were created in the database.

### 3. Data Migration
We migrated all the existing data from the original structure to the new normalized tables while ensuring no data loss.

### 4. Data Integrity Checks
We performed comprehensive checks to ensure data consistency and integrity after the migration. This was done using constraints, triggers, and custom checks.

### 5. Introducing the OrderGroup Entity
We introduced a new entity called **OrderGroup** to represent grouped orders. Instead of creating a new table for this entity, we added two calculated columns to the `OrderItem` table:
- `TotalLineItems`: Represents the total number of items in an order group.
- `SavedTotal`: The total saved from discounts or promotions.

### 6. Indexing for Performance Optimization
To improve query performance, we implemented:
- **Clustered indexes** on primary key columns to optimize data retrieval.
- **Non-clustered indexes** on frequently queried columns to speed up search operations.
- Subtree cost for "Total Sales per Customer" reduced by 61%
- Subtree cost for "Total Sales per Product" reduced by 13%
- Subtree cost for "Total Sales per City" reduced by 35%

![metrics](https://github.com/user-attachments/assets/66799d90-fdc0-4191-807f-f6c071133768)


---

## Key Features Implemented

### 7. Stored Procedures
We developed two stored procedures to handle order creation:
- **prCreateOrderGroup**: Handles the creation of a new order group.
- **prCreateOrderItem**: Inserts a new order item, linked to an order group.

### 8. Error Handling
Robust error-handling mechanisms were added to the stored procedures and database transactions to ensure data consistency and recoverability in case of failures.

---

## Business Intelligence Platform

### 9. Data Source View (DSV)
We designed a **Data Source View (DSV)** in SSAS to create an abstraction of the database and define the relationships between tables.

### 10. Cube Design
We created a multidimensional cube with the following components:
- **Measures**: Sales amount, total items, total orders, and revenue.
- **Dimensions**: Time, customer, product, and geography.

### 11. BI Solution Export
The BI solution was exported and packaged for deployment in a Microsoft SQL Server environment, providing actionable insights through cube measures and dimensions.


### Some Examples:
- Quantity Ordered by Date
![Quantity Ordered by Date](https://github.com/user-attachments/assets/49a40bd6-7841-4004-b350-b52ec155b28c)

- Sales and Quantity by Day
![Sales and Quantity by day](https://github.com/user-attachments/assets/9fc26b6f-d675-4a46-97ff-d9a51b384063)

- Sales and Quantity by Product
![Sales and Quantity by Product](https://github.com/user-attachments/assets/74916ec9-00e6-479a-aee4-9ef138fbda25)


