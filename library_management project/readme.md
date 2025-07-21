📚 Library Management SQL Project
This project consists of SQL scripts that perform basic and advanced database operations for managing a library system using a relational database. It includes tasks such as inserting, updating, deleting, and retrieving data spanning across key library-related tables including books, members, issued books, return tracking, employees, and library branches.

🗂️ Database Tables

Table Name	Description
books	Stores details of books available in the library
members	Holds information about registered library members
employees	Details of library employees
issued_status	Tracks book issue transactions
return_status	Logs return records associated with book issues
branch	Information about library branches including locations and IDs


✅ Project Tasks & SQL Operations
1. Add a New Book
Inserts a new book into the books table:

sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
2. Update a Member’s Address
Updates the address of an existing member (member_id = 'C101'):

sql
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
3. Delete a Book Issue Record
Removes a book issue identified by issued_id = 'IS121':

sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
4. List Books Issued by an Employee
Retrieves all book issuance records handled by employee E101:

sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';
5. List Employees Who Issued More Than One Book
Finds employees who issued more than one book, using aggregation:

sql
SELECT ist.issued_emp_id, e.emp_name
FROM issued_status AS ist
JOIN employees AS e ON e.emp_id = ist.issued_emp_id
GROUP BY ist.issued_emp_id, e.emp_name
HAVING COUNT(ist.issued_id) > 1;
6. Retrieve Books by Category
Lists all books in the 'Classic' category:

sql
SELECT * FROM books
WHERE category = 'Classic';
7. Calculate Total Rental Income by Category
Computes the total rental income and number of issued books per category:

sql
SELECT b.category, SUM(b.rental_price) AS total_income, COUNT(*) AS total_issued
FROM books AS b
JOIN issued_status AS ist ON ist.issued_book_isbn = b.isbn
GROUP BY b.category;
8. List Recently Registered Members
Finds members who registered within the last 180 days:

sql
SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';


