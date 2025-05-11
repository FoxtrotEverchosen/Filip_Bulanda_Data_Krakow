use droptime;

-- GET data about the total weight per product ordered by the customer with customerId = 32 delivered on February 13, 2024. 
select op.product_id, (quantity * weight) as totalWeight
from orders_products op inner join products p
	on op.product_id = p.product_id inner join orders o
	on op.order_id = o.order_id inner join route_segments r
    on op.order_id = r.order_id
where customer_id = 32 and segment_end_time like '2024-02-13%'
order by totalWeight asc;

-- view into data in joined tables
select * from route_segments rs left join orders o
on rs.order_id = o.order_id
order by driver_id, segment_start_time asc;

-- create new column for calculated delivery time
alter table orders
add column total_delivery_time INT;

-- calculate delivery time and put it in orders talbe
update orders o inner join(
    select
        order_id,
        sum(timestampdiff(second, segment_start_time, segment_end_time)) as total_delivery_time
    from  route_segments
    where segment_type = 'STOP' and order_id IS NOT NULL
    group by order_id
) rs on o.order_id = rs.order_id
SET o.total_delivery_time = rs.total_delivery_time;

-- orderID, sectorID, pred_delivery, calculated_delivery, pred_error
select order_id,
	   sector_id,
	   planned_delivery_duration,
       total_delivery_time,
       (planned_delivery_duration - total_delivery_time ) as difference
from orders
where total_delivery_time < 720 AND total_delivery_time > 0;

-- it appears that drivers have significantly different average delivery times in each district.
-- lower driver_id corelates to shorter delivery times
-- most significant outliers and error data filtered out
select driver_id,
	   sector_id,
	   sum(total_delivery_time)/60 as sum_time_min,
       count(*) as order_count,
       sum(total_delivery_time)/count(*) as average_delivery_time,
       count(distinct customer_id) as customer_count
from orders o join route_segments rs
on o.order_id = rs.order_id
where total_delivery_time < 720 AND total_delivery_time > 0
group by driver_id, sector_id
order by sector_id, driver_id asc;


-- average_delivery_time per driver [sec]
select driver_id,
       sum(total_delivery_time)/count(*) as average_delivery_time
from orders o join route_segments rs
on o.order_id = rs.order_id
where total_delivery_time < 720 AND total_delivery_time > 0
group by driver_id
order by driver_id asc;

-- average delivery time per sector [sec]
select sector_id,
       sum(total_delivery_time)/count(*) as average_delivery_time
from orders o join route_segments rs
on o.order_id = rs.order_id
where total_delivery_time < 720 AND total_delivery_time > 0
group by sector_id
order by sector_id asc;

-- try to correlate order weight with delivery time
select quantity,
	   weight,
       (quantity * weight) as totWeigh,
       total_delivery_time,
       sector_id,
       driver_id
from orders_products op inner join products p
	on op.product_id = p.product_id inner join orders o
	on op.order_id = o.order_id inner join route_segments r
    on op.order_id = r.order_id
where total_delivery_time < 720 AND total_delivery_time > 0;

-- rows from most significant columns from all tables, that have not null product_id (what follows - have no null values)
select total_delivery_time,
	   op.order_id,
	   p.product_id,
       quantity,
       weight,
       o.customer_id,
       sector_id,
       driver_id
from orders_products op inner join products p
	on op.product_id = p.product_id inner join orders o
	on op.order_id = o.order_id inner join route_segments r
    on op.order_id = r.order_id
where total_delivery_time < 720 AND total_delivery_time > 0;

-- orderID, driverID, delivery_time
select distinct o.order_id, driver_id, total_delivery_time
from orders o inner join route_segments rs
on o.order_id = rs.order_id
where total_delivery_time < 720 AND total_delivery_time > 0
order by driver_id asc;

-- count of order IDs in data
select o.order_id, count(*)
from orders o inner join route_segments rs
on o.order_id = rs.order_id
where total_delivery_time < 720 AND total_delivery_time > 0
group by o.order_id;


