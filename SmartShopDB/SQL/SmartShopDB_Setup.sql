-- =======================================================
-- STEP 0: Drop the database if it exists (start fresh)
-- =======================================================
IF DB_ID('SmartShopDB') IS NOT NULL
BEGIN
    DROP DATABASE SmartShopDB;
END
GO

-- =======================================================
-- STEP 1: Create the database
-- =======================================================
CREATE DATABASE SmartShopDB;
GO

-- Use the database
USE SmartShopDB;
GO

-- =======================================================
-- STEP 2: Create Tables
-- =======================================================

-- Branches Table
CREATE TABLE dbo.Branches (
    branch_id INT PRIMARY KEY IDENTITY(1,1),
    branch_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    manager_name VARCHAR(100)
);
GO

-- Customers Table
CREATE TABLE dbo.Customers (
    customer_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- Products Table
CREATE TABLE dbo.Products (
    product_id INT PRIMARY KEY IDENTITY(1,1),
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES dbo.Branches(branch_id)
);
GO

-- Orders Table
CREATE TABLE dbo.Orders (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    total_amount DECIMAL(10,2),
    order_type VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES dbo.Customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES dbo.Branches(branch_id)
);
GO

-- Order_Items Table (junction table for many-to-many)
CREATE TABLE dbo.Order_Items (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES dbo.Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES dbo.Products(product_id)
);
GO

-- Payments Table (1-to-1 with Orders)
CREATE TABLE dbo.Payments (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT UNIQUE,
    payment_method VARCHAR(50),
    payment_amount DECIMAL(10,2),
    payment_date DATETIME DEFAULT GETDATE(),
    payment_status VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES dbo.Orders(order_id)
);
GO

-- =======================================================
-- STEP 3: Insert Sample Data
-- =======================================================

-- Branches
INSERT INTO dbo.Branches (branch_name, location, manager_name)
VALUES 
('Colombo Central', 'Colombo', 'Nimal Perera'),
('Kandy City', 'Kandy', 'Saman Silva'),
('Online Warehouse', 'Distribution Center', 'Online Manager');
GO

-- Customers
INSERT INTO dbo.Customers (first_name, last_name, email, phone, address)
VALUES
('Kasun', 'Fernando', 'kasun@email.com', '0771234567', 'Colombo'),
('Malini', 'Perera', 'malini@email.com', '0719876543', 'Kandy'),
('Ruwan', 'Silva', 'ruwan@email.com', '0751122334', 'Galle');
GO

-- Products
INSERT INTO dbo.Products (product_name, category, price, stock_quantity, branch_id)
VALUES
('Laptop', 'Electronics', 250000, 10, 1),
('Smartphone', 'Electronics', 150000, 20, 1),
('Office Chair', 'Furniture', 45000, 15, 2),
('Headphones', 'Electronics', 15000, 30, 3);
GO

-- Orders
INSERT INTO dbo.Orders (customer_id, branch_id, total_amount, order_type)
VALUES
(1, 1, 265000, 'In-Store'),
(2, 2, 45000, 'In-Store'),
(3, 3, 15000, 'Online');
GO

-- Order Items
INSERT INTO dbo.Order_Items (order_id, product_id, quantity, unit_price, subtotal)
VALUES
(1, 1, 1, 250000, 250000),
(1, 4, 1, 15000, 15000),
(2, 3, 1, 45000, 45000),
(3, 4, 1, 15000, 15000);
GO

-- Payments
INSERT INTO dbo.Payments (order_id, payment_method, payment_amount, payment_status)
VALUES
(1, 'Credit Card', 265000, 'Completed'),
(2, 'Cash', 45000, 'Completed'),
(3, 'Debit Card', 15000, 'Completed');
GO

-- =======================================================
-- STEP 4: Quick Verification Queries
-- =======================================================

-- Check tables
SELECT * FROM dbo.Branches;
SELECT * FROM dbo.Customers;
SELECT * FROM dbo.Products;
SELECT * FROM dbo.Orders;
SELECT * FROM dbo.Order_Items;
SELECT * FROM dbo.Payments;

-- Check join
SELECT 
    o.order_id,
    c.first_name AS CustomerName,
    b.branch_name AS Branch,
    p.product_name AS Product,
    oi.quantity,
    o.total_amount
FROM dbo.Orders o
JOIN dbo.Customers c ON o.customer_id = c.customer_id
JOIN dbo.Branches b ON o.branch_id = b.branch_id
JOIN dbo.Order_Items oi ON o.order_id = oi.order_id
JOIN dbo.Products p ON oi.product_id = p.product_id;
GO