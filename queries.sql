-- Name: Angad Brar
-- Computing ID: zqq4hx

-- **World Database Queries**

-- Easy Queries
-- 1. List all countries in South America
SELECT Name 
FROM Country 
WHERE Continent = 'South America';

-- 2. Find the population of 'Germany'
SELECT Population 
FROM Country 
WHERE Name = 'Germany';

-- 3. Retrieve all cities in the country 'Japan'
SELECT Name 
FROM City 
WHERE CountryCode = (
    SELECT Code 
    FROM Country 
    WHERE Name = 'Japan'
);

-- Medium Queries
-- 4. Find the 3 most populated countries in the 'Africa' region
SELECT Name, Population 
FROM Country 
WHERE Region = 'Africa' 
ORDER BY Population DESC 
LIMIT 3;

-- 5. Retrieve the country and its life expectancy where the population is between 1 and 5 million
SELECT Name, LifeExpectancy 
FROM Country 
WHERE Population BETWEEN 1000000 AND 5000000;

-- 6. List countries with an official language of 'French'
SELECT DISTINCT c.Name 
FROM Country c 
JOIN CountryLanguage cl 
ON c.Code = cl.CountryCode 
WHERE cl.Language = 'French' AND cl.IsOfficial = 'T';

-- **Chinook Database Queries**

-- Easy Queries
-- 7. Retrieve all album titles by the artist 'AC/DC'
SELECT Title 
FROM Album 
WHERE ArtistId = (
    SELECT ArtistId 
    FROM Artist 
    WHERE Name = 'AC/DC'
);

-- 8. Find the name and email of customers located in 'Brazil'
SELECT FirstName, LastName, Email 
FROM Customer 
WHERE Country = 'Brazil';

-- 9. List all playlists in the database
SELECT Name 
FROM Playlist;

-- Medium Queries
-- 10. Find the total number of tracks in the 'Rock' genre
SELECT COUNT(*) AS TotalTracks 
FROM Track 
WHERE GenreId = (
    SELECT GenreId 
    FROM Genre 
    WHERE Name = 'Rock'
);

-- 11. List all employees who report to 'Nancy Edwards'
SELECT FirstName, LastName 
FROM Employee 
WHERE ReportsTo = (
    SELECT EmployeeId 
    FROM Employee 
    WHERE FirstName = 'Nancy' AND LastName = 'Edwards'
);

-- 12. Calculate the total sales per customer by summing the total amount in invoices
SELECT c.FirstName, c.LastName, SUM(i.Total) AS TotalSales 
FROM Customer c 
JOIN Invoice i 
ON c.CustomerId = i.CustomerId 
GROUP BY c.CustomerId 
ORDER BY TotalSales DESC;

-- **Custom Database Creation and Queries**

-- Create Tables
CREATE TABLE Books (
    BookID INTEGER PRIMARY KEY AUTOINCREMENT,
    Title TEXT NOT NULL,
    Author TEXT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Stock INTEGER NOT NULL
);

CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY AUTOINCREMENT,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Email TEXT NOT NULL UNIQUE,
    Phone TEXT
);

CREATE TABLE Orders (
    OrderID INTEGER PRIMARY KEY AUTOINCREMENT,
    CustomerID INTEGER,
    BookID INTEGER,
    Quantity INTEGER NOT NULL,
    OrderDate DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

-- Insert Data into Custom Database
INSERT INTO Books (Title, Author, Price, Stock) 
VALUES
('Book A', 'Author 1', 15.99, 10),
('Book B', 'Author 2', 12.49, 20),
('Book C', 'Author 3', 20.00, 5),
('Book D', 'Author 4', 8.99, 15),
('Book E', 'Author 5', 25.50, 8);

INSERT INTO Customers (FirstName, LastName, Email, Phone) 
VALUES
('John', 'Doe', 'john.doe@example.com', '123-456-7890'),
('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210'),
('Alice', 'Brown', 'alice.brown@example.com', '456-789-1230'),
('Bob', 'Johnson', 'bob.johnson@example.com', '321-654-9870'),
('Carol', 'Davis', 'carol.davis@example.com', '789-123-4560');

INSERT INTO Orders (CustomerID, BookID, Quantity) 
VALUES
(1, 1, 2),
(2, 3, 1),
(3, 2, 4),
(4, 5, 1),
(5, 4, 3);

-- Queries on Custom Database

-- 1. Find all customers who purchased 'Book A'
SELECT c.FirstName, c.LastName 
FROM Customers c 
JOIN Orders o 
ON c.CustomerID = o.CustomerID 
JOIN Books b 
ON o.BookID = b.BookID 
WHERE b.Title = 'Book A';

-- 2. Retrieve the total sales for each book
SELECT b.Title, SUM(o.Quantity * b.Price) AS TotalSales 
FROM Books b 
JOIN Orders o 
ON b.BookID = o.BookID 
GROUP BY b.BookID 
ORDER BY TotalSales DESC;

-- 3. Find books with less than 5 units in stock
SELECT Title, Stock 
FROM Books 
WHERE Stock < 5;
