-- create the table

create table category(
category_id varchar primary key,
category_name varchar
);

create table stores(
store_id varchar primary key,
store_name varchar,
city varchar,
country varchar
);

create table products(
product_id varchar primary key,
product_name varchar,
category_id varchar,
launch_date date,
price float,
constraint fk_category foreign key(category_id)
references category(category_id)
);

create table sales(
sales_id varchar primary key,
sale_date date,
store_id varchar,
product_id varchar,
quantity int,
constraint fk_store foreign key(store_id) references
stores(store_id),
constraint fk_product foreign key(product_id) references
products(product_id)
);

-- change the name of the sales to sale

ALTER TABLE sales
RENAME COLUMN sales_id TO sale_id;

 --
 
create table warrenty(
claim_id varchar primary key,
claim_date date,
sale_id varchar,
repair_status varchar,
constraint fk_orders foreign key(sale_id) references
sales(sale_id)
);

--Success message
select 'Schema created successful' as Success_message;



-- Apply sales project - 1M rows sales dataset

select * from sales;
select * from category;
select * from products;
select * from stores;
select * from warrenty;

--EDA

select DISTINCT(REPAIR_STATUS) from warrenty;

select COUNT(*) from SALES;

--Improving Query performace

create index sales_product_index on sales(product_id);
create index sales_store_id on sales(store_id);
create index sales_sale_date on sales(sale_date);

--et - 229.ms
--pt - 2.ms
--et after index 21. ms

explain analyze
select * from sales
where store_id ='ST-31'

-- Business Problme
1.Find the number of stores in each country.

select * from stores;

select country,count(store_name) as total_stores
from stores group by 1 
order by 2 desc

2.Calculate the total number of units sold by each store.

select * from sales

select s.store_id,
st.store_name,
sum(s.quantity) as total_unit_sold
from sales as s
join 
stores as st
on st.store_id = s.store_id
group by 1,2
order by 3 desc

3.Identify how many sales occurred in December 2023.

select * from sales

select 
count(sale_id) as total_sales
from sales
where to_char(sale_date,'MM-YYYY') = '12-2023';


4.Determine how many stores have never had a warranty claim filed.

select count(*) from stores
where store_id NOT IN(
                        select distinct store_id
                        from sales as s
                        RIGHT JOIN warrenty as w
                        on s.sale_id = w.sale_id
                        )

5.Calculate the percentage of warranty claims marked as "Rejected".

select * from warrenty

select 
round(
count(case when repair_status ='Rejected' then 1 end )* 100.0
/count(*),2
) as rejected_percentage
from warrenty

6.Identify which store had the highest total units sold in the last 2 year.

select * from sales

select s.store_id ,
      st.store_name ,
      sum(s.quantity) from sales as s
	  join stores as st
	  on s.store_id = st.store_id
      where sale_date >= ( current_date - interval '2 year')
group by 1,2
order by 3 desc
limit 1

or 

select current_date - INTERVAL '2 YEAR'

select s.store_id ,
      st.store_name ,
      sum(s.quantity) from sales as s
	  join stores as st
	  on s.store_id = st.store_id
      where sale_date BETWEEN '2023-12-28' AND '2024-12-31'
group by 1,2
order by 3 desc
limit 1

7.Count the number of unique products sold in the last year.

select * from sales;

select 
count(DISTINCT(Product_id))
from sales
where sale_date >= ( current_date - interval '2 year')

8.Find the average price of products in each category.

select * from category;
select * from products;

select 
c.category_id,
c.category_name,
avg(p.price) 
from category as c
left join products as p
on c.category_id = p.category_id
group by 1,2
order by 3 desc

 or
 
select category_id,avg(price) from products
group by category_id
order by 2 desc


9.How many warranty claims were filed in 2021?

select count(*)
from warrenty
where extract(year from claim_date) = 2024

10.For each store, identify the best-selling day based on highest quantity sold.

select * from(
select 
store_id,
sum(quantity) as total_sales,
to_char(sale_date,'DAY') as Day_Name,
rank() over(partition by store_id order by sum(quantity) desc ) as rank
from sales
group by 1,3) as t1
where rank= 1


select 
store_id,
sum(quantity) as total_sales,
to_char(sale_date,'DAY') as Day_Name,
rank() over(partition by store_id order by sum(quantity) desc ) as rank
from sales
group by 1,3) as t1	
where rank= 1


----Medium to Hard Questions

11. Identify the least selling product in each country for each year based on total units sold.

with Product_rank as  (
select st.country,
P.Product_name,
s.Product_id,
sum(s.Quantity),
rank() over( partition by st.country order by sum(s.Quantity),st.country) as rank
from sales as s
join Stores as st
on s.store_id = st.store_id
join products as P
on S.product_id = P.product_id
group by 1,2,3
) 
select * from
Product_rank
where rank = 1

12. Calculate how many warranty claims were filed within 180 days of a product sale.

select count(*)
from warrenty as w
left join sales as s
on w.sale_id = s.sale_id
where 
w.claim_date - sale_date <=180

13. Determine how many warranty claims were filed for products launched in the last two years.

select 
p.Product_name,
count(w.claim_id) as no_claim,
count(s.sale_id)
from warrenty as w
join sales as s
on w.sale_id = s.sale_id
JOIN PRODUCTS AS P 
ON p.PRODUCT_ID = S.PRODUCT_ID
where p.LAUNCH_DATE>= CURRENT_DATE - INTERVAL '2 YEARS'
group by product_name
having count(s.sale_id)>=1

14. List the months in the last three years where sales exceeded 5,000 units in the USA.

select 
to_char(s.sale_date,'YYYY-MM') AS MONTH,
sum(s.quantity) as Total_Quantity
from sales as s
join stores as st
on s.store_id = st.store_id
where country = 'Australia'
and
s.sale_date > current_date - interval '3 year'
group by 1
Having sum(quantity) > 5000

15. Identify the product category with the most warranty claims filed in the last two years.

select c.category_name,
count(w.CLAIM_ID) AS TOTAL_CLAIM
from warrenty as w
join sales as s
on w.sale_id = s.sale_id
join products as P
on s.product_id = p.product_id
join category as C
on p.category_id = c.category_id
where W.CLAIM_date >= (CURRENT_DATE - INTERVAL '2YEAR')
group by 1

16.Determine the percentage chance of receiving warranty claims after each purchase for each country.

17.Analyze the year-by-year growth ratio for each store.
18.Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
19.Identify the store with the highest percentage of "Paid Repaired" claims relative to total claims filed.
20.Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.