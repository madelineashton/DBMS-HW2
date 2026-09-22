-- CSC 151: HW #2
create database coffeeshops; -- creating database
use coffeeshops; -- selecting database to use
set SQL_SAFE_UPDATES=0;
set FOREIGN_KEY_CHECKS=0;

-- 5 tables created as csv files via Google Sheets and uploaded to the database
-- using Import Wizard

-- primary keys: baristaID, pastryID, shopID
-- foreign keys: baristaID, pastryID, shopID
-- composite keys: employs(baristaID, shop) and offers(shopID, pastryID)

select * from pastries;
-- 1. Find the average price of pastries for each category from the pastries table.
select
	category,
    avg(price)
from pastries 
group by category;

select * from baristas;
-- 2. Find the total number of baristas at each experience level from the baristas table.
select
	experience_level,
    count(name)
from baristas
group by experience_level;

select * from shops;
-- 3.Count the total number of shops located in each city from the shops table.
select
	city,
    count(name)
from shops
group by city;

-- 4. Find the maximum price among pastries for each category from the pastries table.
select
	category,
    max(price)
from pastries
group by category;

select * from offers;
-- 5. Count how many pastries have been added by each shop using the shopID column from the offers table.
select
	shopID,
    count(pastryID)
from offers
group by shopID;

-- 6. Find the name, category, and price of any pastry whose price 
-- matches the maximum price within its category.
select
	name,
    category,
    price
from pastries p1
where price = (
	select max(price)
    from pastries p2
    where p1.category = p2.category
    group by category
	);
    
-- 7. Find the unique shop IDs from the offers table that have offered at least 
-- one pastry whose price is strictly greater than the overall average price of all pastries.
select
	distinct shopID
from offers
where pastryID in (
	select pastryID
    from pastries
		where price > (
			select avg(price)
            from pastries)
            );
            
-- 8. Find the shop ID and pastry ID for the records in the offers table that have the earliest 
-- date_added (minimum date).
select
	shopID, 
    pastryID
from offers
where date_added <= all
		(select date_added
        from offers);
        
-- 9. Find the shop ID(s) that offer the highest number of pastries, utilizing 
-- a subquery to evaluate the maximum count per shop.
select
	shopID,
    count(pastryID)
from offers
group by shopID
having count(pastryID) >= all
		(select count(pastryID)
        from offers
        group by shopID);

select * from baristas;
select * from employs;
select * from shops;       
-- 10. Find the names of baristas who work at shops located in 'Seattle' using nested subqueries.
select
	name
from baristas
where baristaID in 
	(select baristaID
    from employs
    where shopID in
		(select shopID
        from shops
        where city = 'Seattle')
        );
