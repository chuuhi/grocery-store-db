-- Grocery Store Database
-- Basic database for managing grocery store operations

CREATE DATABASE GroceryStoreDB;
USE GroceryStoreDB;

-- Categories table
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

-- Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(200) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100)
);

-- Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Order Items table
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Add some basic data
INSERT INTO Categories (category_name) VALUES
('Fruits'),
('Vegetables'),
('Dairy'),
('Meat'),
('Beverages'),
('Snacks');

INSERT INTO Products (product_name, category_id, price, stock_quantity) VALUES
('Bananas', 1, 2.99, 50),
('Apples', 1, 4.99, 30),
('Carrots', 2, 2.49, 25),
('Milk', 3, 3.49, 40),
('Ground Beef', 4, 12.99, 15),
('Coca Cola', 5, 3.49, 60),
('Potato Chips', 6, 3.99, 35);

INSERT INTO Customers (first_name, last_name, email) VALUES
('John', 'Smith', 'john@email.com'),
('Sarah', 'Johnson', 'sarah@email.com'),
('Mike', 'Davis', 'mike@email.com');

INSERT INTO Orders (customer_id, total_amount) VALUES
(1, 15.97),
(2, 8.48),
(1, 12.99),
(3, 10.48);

INSERT INTO Order_Items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 2.99),
(1, 3, 1, 2.49),
(1, 4, 3, 3.49),
(2, 2, 1, 4.99),
(2, 6, 1, 3.49),
(3, 5, 1, 12.99),
(4, 1, 1, 2.99),
(4, 7, 2, 3.99);

-- Basic queries for analysis

-- Total sales by product
SELECT 
    p.product_name,
    SUM(oi.quantity) as total_sold,
    SUM(oi.quantity * oi.price) as revenue
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY revenue DESC;

-- Sales by category
SELECT 
    c.category_name,
    COUNT(oi.order_item_id) as items_sold,
    SUM(oi.quantity * oi.price) as total_revenue
FROM Categories c
JOIN Products p ON c.category_id = p.category_id
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY c.category_id;

-- Customer orders
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Products running low (less than 20 in stock)
SELECT 
    product_name,
    stock_quantity
FROM Products
WHERE stock_quantity < 20
ORDER BY stock_quantity;

-- Daily sales
SELECT 
    DATE(order_date) as sale_date,
    COUNT(*) as number_of_orders,
    SUM(total_amount) as daily_total
FROM Orders
GROUP BY DATE(order_date);

-- Most popular products
SELECT 
    p.product_name,
    SUM(oi.quantity) as times_ordered
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY times_ordered DESC;