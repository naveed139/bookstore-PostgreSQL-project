drop table if exists books;

create table books(
Book_ID serial primary key,
Title varchar(100),
Author varchar(100),
Genre varchar(50),
Published_Year int,
Price numeric(10,2),
Stock int
);

drop table if exists customers;

create table customers(
Customer_ID serial primary key,
Name varchar(50),
Email varchar(50),
Phone varchar(15),
City varchar(50),
Country varchar(100)
);

drop table if exists orders;

create table orders(
Order_ID serial primary key,
Customer_ID int references customers(Customer_ID),
Book_ID int references books(Book_ID),
Order_Date Date,
Quantity int,
Total_Amount numeric(10,2)
);

select * from books;
select * from customers;
select * from orders;

--import data from table books

copy Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
from'D:\data\Books.csv'
csv header;

--import data from customer table

copy customers(Customer_ID, Name, Email, Phone, City, Country)
from'D:\data\Customers.csv'
csv header;

--import data from table orders

copy orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
from'D:\data\Orders.csv'
csv header;


select * from books;
select * from customers;
select * from orders;

--retrive all books in the fiction genre

select * from books
where genre='Fiction';

--retrive all books which are published after 1950

select * from books
where published_year>1950;

--list all the customer from canada

select * from customers
where country='Canada';

--show order place in november 2023

select * from orders
where order_date between '2023-11-01' and '2023-11-30';

--retrive the total stock of books

select sum(stock) as total_stock from books;

--find detail of most expensive book

select * from books
order by price desc
limit 1;

--show all the customer who order more than one quantity of book

select * from orders
where quantity >1;

--retrive all the orders where total amount exceed $20

select * from orders
where total_amount>20;

--retrive all genre available in book table

select count(distinct(genre)) as total_genre from books;

--find the book with the lowest stock available

select * from books
order by stock asc 
limit 1;

--calculate total revenue generated from all orders

select sum(total_amount) as total_revenue from orders;

--retrive total number of books sold for each genre
select * from orders;

select * from books;

select b.genre, sum(o.quantity) as total_quantity
from orders o
join books b on b.book_id=o.book_id
group by b.genre;

--find average price of book fantasy genre

select avg(price)
from books
where genre='Fantasy';

--list all customer who placed at least 2 orders

select o.customer_id,c.name,count(o.order_id) as order_count
from orders o
join customers c on o.customer_id=c.customer_id
group by o.customer_id,c.name
having count(order_id)>=2;


--find the most frequenty order book

select * from orders;
select * from customers;
select * from books;

select o.book_id,b.title,count(o.order_id) as order_count
from orders o
join books b on b.book_id=o.book_id
group by o.book_id,b.title
order by order_count desc limit 1;


--show the 3 top most expensive book of 'Fantasy' genre

select * from books
where genre='Fantasy'
order by price desc limit 3;

--retrive the total quantity of book sold by each author


select * from orders;
select * from customers;
select * from books;

select b.author,sum(o.quantity) as total_quantity
from orders o
join books b on b.book_id=o.book_id
group by b.author;

--list the cities where customer who spent more than $30 are located:

select Distinct c.city,total_amount
from orders o
join customers c on o.customer_id=c.customer_id
where o.total_amount>30;

--find the customer who spent the most of an order

select * from customers;
select * from orders;

select c.customer_id,c.name,sum(o.total_amount) as total_spent
from customers c
join orders o on c.customer_id=o.order_id
group by c.customer_id,c.name
order by total_spent desc limit 1;

--calculate the total stock available after fulfilling orders
select * from books;
select * from customers;
select * from orders;

select b.book_id,b.title,b.stock,coalesce(sum(o.quantity),0) as order_quantity,
   b.stock-coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join orders o on b.book_id=o.book_id
group by b.book_id order by b.book_id;
