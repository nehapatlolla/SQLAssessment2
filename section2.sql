use assignment

CREATE TABLE books
(
    book_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author_id INT NOT NULL,
    genre VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE authors
(
    author_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    birth_year INT NOT NULL
);

CREATE TABLE sales
(
    sale_id INT PRIMARY KEY,
    book_id INT NOT NULL,
    sale_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);


INSERT INTO authors
    (author_id, name, country, birth_year)
VALUES
    (1, 'George Orwell', 'UK', 1903),
    (2, 'J.K. Rowling', 'UK', 1965),
    (3, 'Mark Twain', 'USA', 1835),
    (4, 'Jane Austen', 'UK', 1775),
    (5, 'Ernest Hemingway', 'USA', 1899),
    (6, 'Neha reddy', 'USA', 2024)

;
-- drop table authors

INSERT INTO books
    (book_id, title, author_id, genre, price)
VALUES
    (1, '1984', 1, 'Dystopian', 15.99),
    (2, 'Harry Potter and the Philosophers Stone', 2, 'Fantasy', 20.00),
    (3, 'Adventures of Huckleberry Finn', 3, 'Fiction', 10.00),
    (4, 'Pride and Prejudice', 4, 'Romance', 12.00),
    (5, 'The Old Man and the Sea', 5, 'Fiction', 8.99),
    (6, 'Vampire diaries', 1, 'Fiction', 19.76),
    (7, 'True beauty', 2, 'Romance', 20.76),
    (8, ' secretery kim', 3, 'Romance', 17.56),
    (9, 'sofia', 4, 'fantasy', 12.67),
    (10, 'Hometown cha cha', 5, 'Dystopian', 20.67)

;

INSERT INTO sales
    (sale_id, book_id, sale_date, quantity, total_amount)
VALUES
    (1, 1, '2024-01-15', 3, 47.97),
    (2, 2, '2024-02-10', 2, 40.00),
    (3, 3, '2024-03-05', 5, 50.00),
    (4, 4, '2024-04-20', 1, 12.00),
    (5, 5, '2024-05-25', 4, 35.96),
    (6, 6, '2024-06-27', 5, 98.89),
    (7, 7, '2024-01-27', 5, 103.8),
    (8, 8, '2024-01-27', 2, 36.9),
    (9, 9, '2024-02-23', 1, 12.67)
,
insert into sales
values
    (10, 10, '2024-04-27', 2, 25.54);




create table Ratings
(
    book_id int not NULL,
    Rating_id int not null PRIMARY key,
    Rating int not null,
    FOREIGN KEY (book_id) REFERENCES books(book_id)
)

INSERT INTO Ratings
    (book_id, Rating_id, Rating)
VALUES
    (1, 1, 7),
    (2, 2, 8),
    (3, 3, 4),
    (4, 4, 6),
    (5, 5, 5),
    (6, 6, 9),
    (7, 7, 10),
    (1, 8, 10),
    (5, 9, 9),
    (2, 10, 7 )

select *
from books
select *
from authors
select *
from sales
select *
from Ratings


-- Section 2: Questions
-- Task 1: Stored Procedure for Total Sales by Author
-- Create a stored procedure to get the total sales amount for a specific author and write a query to call the procedure for 'J.K. Rowling'.
go
create proc TotalSalesByAuthor
    @name varchar(50)
AS
begin
    select a.author_id, a.name, sum(total_amount) as total
    from sales s
        join books b
        ON b.author_id = s.book_id
        join authors a
        on a.author_id = b.book_id
    where a.name = @name
    GROUP BY a.author_id, a.name
end
go
exec TotalSalesByAuthor @name = 'J.K. Rowling'

-- Task 2: Function to Calculate Total Quantity Sold for a Book
-- Create a function to calculate the total quantity sold for a given book title and write a query to use this function for '1984'.
go
create function dbo.TotalQuantitySold(
    @title varchar(50)
)
returns table
AS
RETURN(
  select b.book_id, b.title, sum(s.quantity) as total
from sales s
    join books b
    ON b.book_id = s.book_id
where b.title = @title
GROUP BY b.book_id, b.title
    );

go

select *
from dbo.TotalQuantitySold ('1984')

-- Task 3: View for Best-Selling Books
-- Create a view to show the best-selling books (those with total sales amount above $30) and write a query to select from this view.

go
create view viewBestSellingBooks
as
    select b.book_id, b.title, sum(s.total_amount) as total
    from sales s
        join books b
        ON b.book_id = s.book_id
    GROUP BY b.book_id, b.title
    having sum(s.total_amount) > 30
go

select *
from viewBestSellingBooks
Go

-- Task 4: Stored Procedure for Average Book Price by Author
-- Create a stored procedure to get the average price of books for a specific author and write a query to call the procedure for 'Mark Twain'.

create proc AverageBookPricebyAuthor
    @authname varchar(50)
AS
BEGIN
    select b.title, avg(price)
    from books b
        join authors a
        on a.author_id = b.author_id
    where name= @authname
    group by name, b.title
END
exec AverageBookPricebyAuthor @authname= 'Mark Twain'

-- Task 5: Function to Calculate Total Sales in a Month
-- Create a function to calculate the total sales amount in a given month and year, and write a query to use this function for January 2024.
go
create function CalculateTotalSalesinaMonth(
    @month varchar(50), @year int
)
RETURNS TABLE
AS
return 
(
    select sum(total_amount) as total
from sales
where DATENAME(month, sale_date) = @month and year(sale_date) = @year
)
GO
select *
from CalculateTotalSalesinaMonth('January', 2024)
GO

-- Task 6: View for Authors with Multiple Genres
-- Create a view to show authors who have written books in multiple genres and write a query to select from this view.
go
create view AuthorswithMultipleGenres
AS
    select a.author_id, a.name , count(distinct genre) as Multiplegenres
    from authors a
        join books b
        on b.author_id = a.author_id
    group by a.author_id, a.name
    having  count(distinct genre) >1
go
select *
from AuthorswithMultipleGenres

-- Task 7: Ranking Authors by Total Sales
-- Write a query to rank authors by their total sales amount and display the top 3 authors.
go
with
    cte4
    as
    (
        select a.name,
            rank() over(order by sum(total_amount) desc) as rank
        from sales s
            join books b
            on b.book_id = s.book_id
            join authors a
            on a.author_id = b.author_id
        group by a.author_id, a.name
    )
select name, rank
from cte4
where rank <=3

-- Task 8: Stored Procedure for Top-Selling Book in a Genre
-- Create a stored procedure to get the top-selling book in a specific genre and write a query to call the procedure for 'Fantasy'.
go
create proc TopSellingBookinaGenre
    @genre varchar(50)
AS
BEGIN
    with
        cte5
        AS
        (
            select b.title, b.genre,
                rank() over(order by s.quantity desc) as rank
            from sales s
                join books b
                on b.book_id = s.book_id
                join authors a
                on a.author_id = b.author_id
            where genre = @genre
            group by b.genre, s.quantity, b.title
        )
    select title, rank  , genre
    from cte5
    where rank <2
END
exec TopSellingBookinaGenre @genre = 'Fantasy'

-- Task 9: Function to Calculate Average Sales Per Genre
-- Create a function to calculate the average sales amount for books in a given genre and write a query to use this function for 'Romance'.
go
create function CalculateAverageSalesPerGenre
(
    @genre varchar(50)
)
returns table 
AS
RETURN
(
    select genre, avg(total_amount) as average
from sales s
    join books b
    on b.book_id = s.book_id
where genre= @genre
group by genre

)
go
select *
from CalculateAverageSalesPerGenre ('Romance')
