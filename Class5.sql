
create database test;

use test;

create table customers
(
    id int,
    name varchar(50)
);

create table orders
(
    order_id int,
    amount int,
    cust_id int
);

insert into customers values(1,'John');

insert into customers values(2,'David');

insert into customers values(3,'Ronn');

insert into customers values(4,'Betty');


insert into orders values(1,100,10);

insert into orders values(2,500,3);

insert into orders values(3,300,6);

insert into orders values(4,800,2);

insert into orders values(5,350,1);

select * from customers;

select * from orders;

# Get the orders information along with customers full details
# if order amount were greater than 400

select c.*,o.* 
from orders o
inner join customers c on o.cust_id=c.id
where o.amount >400;

select c.*,o.* 
from orders o
inner join customers c on o.cust_id=c.id and o.amount >400;


# Window Functions
create table shop_sales_data
(
sales_date date,
shop_id varchar(5),
sales_amount int
);

insert into shop_sales_data values('2022-02-14','S1',200);
insert into shop_sales_data values('2022-02-15','S1',300);
insert into shop_sales_data values('2022-02-14','S2',600);
insert into shop_sales_data values('2022-02-15','S3',500);
insert into shop_sales_data values('2022-02-18','S1',400);
insert into shop_sales_data values('2022-02-17','S2',250);
insert into shop_sales_data values('2022-02-20','S3',300);

# Total count of sales for each shop using window function
# Working functions - SUM(), MIN(), MAX(), COUNT(), AVG()

# If we only use Order by In Over Clause
select *,
       sum(sales_amount) over(order by sales_amount desc) as total_sum_of_sales
from shop_sales_data;

# If we only use Partition By
select *,
       sum(sales_amount) over(partition by shop_id) as total_sum_of_sales
from shop_sales_data;

# If we only use Partition By & Order By together
select *,
       sum(sales_amount) over(partition by shop_id order by sales_amount desc) as total_sum_of_sales
from shop_sales_data;

select shop_id, count(*) as total_sale_count_by_shops from shop_sales_data group by shop_id;

create table amazon_sales_data
(
    sales_data date,
    sales_amount int
);

insert into amazon_sales_data values('2022-08-21',500);
insert into amazon_sales_data values('2022-08-22',600);
insert into amazon_sales_data values('2022-08-19',300);

insert into amazon_sales_data values('2022-08-18',200);

insert into amazon_sales_data values('2022-08-25',800);


# Query - Calculate the date wise rolling average of amazon sales
select * from amazon_sales_data;

select *,
       avg(sales_amount) over(order by sales_data) as rolling_avg
from amazon_sales_data;

select *,
       avg(sales_amount) over(order by sales_data) as rolling_avg,
       sum(sales_amount) over(order by sales_data) as rolling_sum
from amazon_sales_data;

# Rank(), Row_Number(), Dense_Rank() window functions

insert into shop_sales_data values('2022-02-19','S1',400);
insert into shop_sales_data values('2022-02-20','S1',400);
insert into shop_sales_data values('2022-02-22','S1',300);
insert into shop_sales_data values('2022-02-25','S1',200);
insert into shop_sales_data values('2022-02-15','S2',600);
insert into shop_sales_data values('2022-02-16','S2',600);
insert into shop_sales_data values('2022-02-16','S3',500);
insert into shop_sales_data values('2022-02-18','S3',500);
insert into shop_sales_data values('2022-02-19','S3',300);

select *,
       row_number() over(partition by shop_id order by sales_amount desc) as row_num,
       rank() over(partition by shop_id order by sales_amount desc) as rank_val,
       dense_rank() over(partition by shop_id order by sales_amount desc) as dense_rank_val
from shop_sales_data;

+------------+---------+--------------+---------+----------+----------------+
| sales_date | shop_id | sales_amount | row_num | rank_val | dense_rank_val |
+------------+---------+--------------+---------+----------+----------------+
| 2022-02-18 | S1      |          400 |       1 |        1 |              1 |
| 2022-02-19 | S1      |          400 |       2 |        1 |              1 |
| 2022-02-20 | S1      |          400 |       3 |        1 |              1 |
| 2022-02-15 | S1      |          300 |       4 |        4 |              2 |
| 2022-02-22 | S1      |          300 |       5 |        4 |              2 |
| 2022-02-14 | S1      |          200 |       6 |        6 |              3 |
| 2022-02-25 | S1      |          200 |       7 |        6 |              3 |
| 2022-02-14 | S2      |          600 |       1 |        1 |              1 |
| 2022-02-15 | S2      |          600 |       2 |        1 |              1 |
| 2022-02-16 | S2      |          600 |       3 |        1 |              1 |
| 2022-02-17 | S2      |          250 |       4 |        4 |              2 |
| 2022-02-15 | S3      |          500 |       1 |        1 |              1 |
| 2022-02-16 | S3      |          500 |       2 |        1 |              1 |
| 2022-02-18 | S3      |          500 |       3 |        1 |              1 |
| 2022-02-20 | S3      |          300 |       4 |        4 |              2 |
| 2022-02-19 | S3      |          300 |       5 |        4 |              2 |
+------------+---------+--------------+---------+----------+----------------+


create table employees
(
    emp_id int,
    salary int,
    dept_name VARCHAR(30)

);

insert into employees values(1,10000,'Software');
insert into employees values(2,11000,'Software');
insert into employees values(3,11000,'Software');
insert into employees values(4,11000,'Software');
insert into employees values(5,15000,'Finance');
insert into employees values(6,15000,'Finance');
insert into employees values(7,15000,'IT');
insert into employees values(8,12000,'HR');
insert into employees values(9,12000,'HR');
insert into employees values(10,11000,'HR');

select * from employees;

# Query - get one employee from each department who is getting maximum salary (employee can be random if salary is same)

select 
    tmp.*
from (select *,
        row_number() over(partition by dept_name order by salary desc) as row_num
    from employees) tmp
where tmp.row_num = 1;

+--------+--------+-----------+---------+
| emp_id | salary | dept_name | row_num |
+--------+--------+-----------+---------+
|      5 |  15000 | Finance   |       1 |
|      8 |  12000 | HR        |       1 |
|      7 |  15000 | IT        |       1 |
|      2 |  11000 | Software  |       1 |
+--------+--------+-----------+---------+


# Query - get all employees from each department who are getting maximum salary
select 
    tmp.*
from (select *,
        rank() over(partition by dept_name order by salary desc) as rank_num
    from employees) tmp
where tmp.rank_num = 1;
  
+--------+--------+-----------+----------+
| emp_id | salary | dept_name | rank_num |
+--------+--------+-----------+----------+
|      5 |  15000 | Finance   |        1 |
|      6 |  15000 | Finance   |        1 |
|      8 |  12000 | HR        |        1 |
|      9 |  12000 | HR        |        1 |
|      7 |  15000 | IT        |        1 |
|      2 |  11000 | Software  |        1 |
|      3 |  11000 | Software  |        1 |
|      4 |  11000 | Software  |        1 |
+--------+--------+-----------+----------+

# Query - get all top 2 ranked employees from each department who are getting maximum salary
select 
    tmp.*
from (select *,
        dense_rank() over(partition by dept_name order by salary desc) as dense_rank_num
    from employees) tmp
where tmp.dense_rank_num <= 2;

+--------+--------+-----------+----------------+
| emp_id | salary | dept_name | dense_rank_num |
+--------+--------+-----------+----------------+
|      5 |  15000 | Finance   |              1 |
|      6 |  15000 | Finance   |              1 |
|      8 |  12000 | HR        |              1 |
|      9 |  12000 | HR        |              1 |
|     10 |  11000 | HR        |              2 |
|      7 |  15000 | IT        |              1 |
|      2 |  11000 | Software  |              1 |
|      3 |  11000 | Software  |              1 |
|      4 |  11000 | Software  |              1 |
|      1 |  10000 | Software  |              2 |
+--------+--------+-----------+----------------+

# Example for lag and lead
create table daily_sales
(
sales_date date,
sales_amount int
);


insert into daily_sales values('2022-03-11',400);
insert into daily_sales values('2022-03-12',500);
insert into daily_sales values('2022-03-13',300);
insert into daily_sales values('2022-03-14',600);
insert into daily_sales values('2022-03-15',500);
insert into daily_sales values('2022-03-16',200);

select * from daily_sales;

select *,
      lag(sales_amount, 1) over(order by sales_date) as pre_day_sales
from daily_sales;

+------------+--------------+---------------+
| sales_date | sales_amount | pre_day_sales |
+------------+--------------+---------------+
| 2022-03-11 |          400 |          NULL |
| 2022-03-12 |          500 |           400 |
| 2022-03-13 |          300 |           500 |
| 2022-03-14 |          600 |           300 |
| 2022-03-15 |          500 |           600 |
| 2022-03-16 |          200 |           500 |
+------------+--------------+---------------+

# Query - Calculate the differnce of sales with previous day sales
# Here null will be derived
select sales_date,
       sales_amount as curr_day_sales,
       lag(sales_amount, 1) over(order by sales_date) as prev_day_sales,
       sales_amount - lag(sales_amount, 1) over(order by sales_date) as sales_diff
from daily_sales;

+------------+----------------+----------------+------------+
| sales_date | curr_day_sales | prev_day_sales | sales_diff |
+------------+----------------+----------------+------------+
| 2022-03-11 |            400 |           NULL |       NULL |
| 2022-03-12 |            500 |            400 |        100 |
| 2022-03-13 |            300 |            500 |       -200 |
| 2022-03-14 |            600 |            300 |        300 |
| 2022-03-15 |            500 |            600 |       -100 |
| 2022-03-16 |            200 |            500 |       -300 |
+------------+----------------+----------------+------------+

# Here we can replace null with 0
select sales_date,
       sales_amount as curr_day_sales,
       lag(sales_amount, 1, 0) over(order by sales_date) as prev_day_sales,
       sales_amount - lag(sales_amount, 1, 0) over(order by sales_date) as sales_diff
from daily_sales;

+------------+----------------+----------------+------------+
| sales_date | curr_day_sales | prev_day_sales | sales_diff |
+------------+----------------+----------------+------------+
| 2022-03-11 |            400 |              0 |        400 |
| 2022-03-12 |            500 |            400 |        100 |
| 2022-03-13 |            300 |            500 |       -200 |
| 2022-03-14 |            600 |            300 |        300 |
| 2022-03-15 |            500 |            600 |       -100 |
| 2022-03-16 |            200 |            500 |       -300 |
+------------+----------------+----------------+------------+


# Diff between lead and lag
select *,
      lag(sales_amount, 1) over(order by sales_date) as pre_day_sales
from daily_sales;

+------------+--------------+---------------+
| 2022-03-11 |          400 |          NULL |
| 2022-03-12 |          500 |           400 |
| 2022-03-13 |          300 |           500 |
| 2022-03-14 |          600 |           300 |
| 2022-03-15 |          500 |           600 |
| 2022-03-16 |          200 |           500 |
+------------+--------------+---------------+

select *,
      lead(sales_amount, 1) over(order by sales_date) as next_day_sales
from daily_sales;

+------------+--------------+----------------+
| sales_date | sales_amount | next_day_sales |
+------------+--------------+----------------+
| 2022-03-11 |          400 |            500 |
| 2022-03-12 |          500 |            300 |
| 2022-03-13 |          300 |            600 |
| 2022-03-14 |          600 |            500 |
| 2022-03-15 |          500 |            200 |
| 2022-03-16 |          200 |           NULL |
+------------+--------------+----------------+

# How to use Frame Clause - Rows BETWEEN
select * from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between 1 preceding and 1 following) as prev_plus_next_sales_sum
from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between 1 preceding and current row) as prev_plus_next_sales_sum
from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between current row and 1 following) as prev_plus_next_sales_sum
from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between 2 preceding and 1 following) as prev_plus_next_sales_sum
from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between unbounded preceding and current row) as prev_plus_next_sales_sum
from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between current row and unbounded following) as prev_plus_next_sales_sum
from daily_sales;

select *,
      sum(sales_amount) over(order by sales_date rows between unbounded preceding and unbounded following) as prev_plus_next_sales_sum
from daily_sales;

# Alternate way to exclude computation of current row
select *,
      sum(sales_amount) over(order by sales_date rows between unbounded preceding and unbounded following) - sales_amount as prev_plus_next_sales_sum
from daily_sales;

# How to work with Range Between

select *,
      sum(sales_amount) over(order by sales_amount range between 100 preceding and 200 following) as prev_plus_next_sales_sum
from daily_sales;

# Calculate the running sum for a week
# Calculate the running sum for a month
insert into daily_sales values('2022-03-20',900);
insert into daily_sales values('2022-03-23',200);
insert into daily_sales values('2022-03-25',300);
insert into daily_sales values('2022-03-29',250);


select * from daily_sales;

select *,
       sum(sales_amount) over(order by sales_date range between interval '6' day preceding and current row) as running_weekly_sum
from daily_sales;