-- Drop if exists to avoid duplication
DROP DATABASE IF EXISTS KnowledgeHubDB;

-- Create fresh Library Database
CREATE DATABASE KnowledgeHubDB;
USE KnowledgeHubDB;

-- Book Shelf Table
CREATE TABLE BookShelf (
    shelf_id INT PRIMARY KEY AUTO_INCREMENT,
    book_title VARCHAR(150) NOT NULL,
    author_name VARCHAR(100),
    category VARCHAR(50),
    year_published INT,
    copies_available INT
);

-- Member Directory Table
CREATE TABLE MemberDirectory (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    member_name VARCHAR(100) NOT NULL,
    age INT,
    membership_type VARCHAR(30), -- e.g., Regular, Premium
    join_date DATE
);

-- Borrowing Records Table
CREATE TABLE BorrowingRecords (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    shelf_id INT,
    borrow_date DATE,
    return_date DATE,
    returned BOOLEAN,
    FOREIGN KEY(member_id) REFERENCES MemberDirectory(member_id),
    FOREIGN KEY(shelf_id) REFERENCES BookShelf(shelf_id)
);

-- Insert Books
INSERT INTO BookShelf (book_title, author_name, category, year_published, copies_available) VALUES
('The Alchemist', 'Paulo Coelho', 'Fiction', 1988, 5),
('Ikigai', 'Hector Garcia', 'Self-Help', 2016, 3),
('Introduction to Algorithms', 'Thomas H. Cormen', 'Education', 2009, 2),
('War and Peace', 'Leo Tolstoy', 'Classic', 1869, 4),
('Pride and Prejudice', 'Jane Austen', 'Classic', 1813, 3);

-- Insert Members
INSERT INTO MemberDirectory (member_name, age, membership_type, join_date) VALUES
('Arjun Mehta', 21, 'Premium', '2023-01-15'),
('Simran Kaur', 19, 'Regular', '2023-02-20'),
('Rohit Sharma', 24, 'Premium', '2023-03-05'),
('Priya Singh', 20, 'Regular', '2023-03-25'),
('Manpreet Gill', 22, 'Premium', '2023-04-10');

-- Insert Borrowing Records
INSERT INTO BorrowingRecords (member_id, shelf_id, borrow_date, return_date, returned) VALUES
(1, 1, '2023-05-01', '2023-05-15', TRUE),
(2, 2, '2023-05-03', '2023-05-20', FALSE),
(3, 3, '2023-05-05', '2023-05-25', TRUE),
(4, 4, '2023-05-07', '2023-05-30', FALSE),
(5, 5, '2023-05-09', '2023-05-22', TRUE);

-- 1. Find members who have not returned books yet
SELECT m.member_name, b.book_title, r.borrow_date, r.return_date
FROM BorrowingRecords r
JOIN MemberDirectory m ON r.member_id = m.member_id
JOIN BookShelf b ON r.shelf_id = b.shelf_id
WHERE r.returned = FALSE;

-- 2. Show the most borrowed category of books
SELECT b.category, COUNT(r.record_id) AS borrow_count
FROM BorrowingRecords r
JOIN BookShelf b ON r.shelf_id = b.shelf_id
GROUP BY b.category
ORDER BY borrow_count DESC
LIMIT 1;

-- 3. List all Premium members and the books they borrowed
SELECT m.member_name, b.book_title, r.borrow_date
FROM BorrowingRecords r
JOIN MemberDirectory m ON r.member_id = m.member_id
JOIN BookShelf b ON r.shelf_id = b.shelf_id
WHERE m.membership_type = 'Premium';

-- 4. Show books with fewer than 3 copies available (low stock alert)
SELECT book_title, author_name, copies_available
FROM BookShelf
WHERE copies_available < 3;

