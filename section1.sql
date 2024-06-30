create database assignment
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
    (10, 'Little Things', 5, 'Romance', 12.50)

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
    (9, 9, '2024-02-23', 1, 12.67),
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

-- drop table books
-- drop table authors
-- drop table sales
-- drop table ratings

-- Task 1
-- Write a query to display authors who have written books in multiple genres and group the results by author name.
select a.name, count(distinct b.genre) as generess
from authors a
    join books b
    on b.author_id = a.author_id
group by a.name
having count(distinct b.genre)>1

-- Task 2
-- Write a query to find the books that have the highest sale total for each genre and group the results by genre.
with
    cte
    as

    (
        select title, genre, rank() over (partition by genre order by total_amount  desc)  as total
        from sales s
            join books b
            on s.book_id= b.book_id
    )
select *
from cte
where total = 1
order by total desc

-- Task 3
-- Write a query to find the average price of books for each author and group the results by author name, only including authors whose average book price is higher than the overall average book price.

select name, avg(price) as average
from books b
    join authors a
    on a.author_id = b.author_id
group by name
having avg(price) > (select avg(price )
from books)
order by average desc

-- Task 4
-- Write a query to find authors who have sold more books than the average number of books sold per author and group the results by country.
with
    cte
    as
    (
        select b.book_id, b.title, a.author_id, s.sale_id , sum(s.quantity) as sum
        from books b
            join authors a
            on a.author_id = b.author_id
            join sales s
            on s.book_id = b.book_id
        group by b.book_id, b.title, a.author_id,  a. name, s.sale_id
    )
select *
from cte
where sum > (select avg(s.quantity) as average
from sales s)

-- Task 5
-- Write a query to find the top 2 highest-priced books and the total quantity sold for each, grouped by book title.

with
    cte1
    as
    (
        select
            b.price , s.quantity , b.title, rank() over (order by b.price desc )  as tops
        from books b
            join sales s
            on s.book_id = b.book_id
    )
select *
from cte1
where tops <=2


-- Task 6
-- Write a query to display authors whose birth year is earlier than the average birth year of authors from their country and rank them within their country.
with
    cte7
    as
    (
        select country,
            birth_year,
            rank() over (partition by country order by birth_year ) as rank
        from authors a
        where birth_year < 
                  (select avg(birth_year) as avgOfAuthors
        from authors a1
        where a.country = a1.country
        group  by country
                  )
    )
select *
from cte7
where rank <=2

-- Task 7
-- Write a query to find the authors who have written books in both 'Fiction' and 'Romance' genres and group the results by author name.

    SELECT a.name AS author_name
    FROM authors a
        JOIN books b ON a.author_id = b.author_id
    WHERE b.genre = 'Fiction'
INTERSECT
    SELECT a.name AS author_name
    FROM authors a
        JOIN books b ON a.author_id = b.author_id
    WHERE b.genre = 'Romance'
ORDER BY author_name;


-- Task 8
-- Write a query to find authors who have never written a book in the 'Fantasy' genre and group the results by country.

select a.name, a.author_id, b.title , b.genre
from authors a
    join books b
    on b.author_id = a.author_id
where b.genre not like 'fantasy'
-- group by country

-- Task 9
-- Write a query to find the books that have been sold in both January and February 2024 and group the results by book title.



    select b. book_id, title , datepart(month, s.sale_date) as month
    from books b
        join sales s
        on s.book_id = b.book_id
    group by b. book_id, title ,datepart(month, s.sale_date)
    having datepart(month, s.sale_date) =1
intersect
    select b. book_id, title , datepart(month, s.sale_date) as month
    from books b
        join sales s
        on s.book_id = b.book_id
    group by b. book_id, title ,datepart(month, s.sale_date)
    having datepart(month, s.sale_date) =2




-- Task 10
-- Write a query to display the authors whose average book price is higher than every book price in the 'Fiction' genre and group the results by author name.

with
    cte
    as
    (
        select a.name , avg(price) as prices
        from books b
            join authors a
            on a.author_id = b.author_id
        group by a.name
    )
select *
from cte
where prices >
All(
select price
from books
where genre = 'fiction')



