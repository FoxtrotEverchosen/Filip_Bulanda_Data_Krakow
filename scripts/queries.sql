use droptime;

-- GET data about the total weight per product ordered by the customer with customerId = 32 delivered on February 13, 2024. 
select op.product_id, (quantity * weight) as totalWeight
from orders_products op inner join products p
	on op.product_id = p.product_id inner join orders o
	on op.order_id = o.order_id inner join route_segments r
    on op.order_id = r.order_id
where customer_id = 32 and segment_end_time like '2024-02-13%'
order by totalWeight asc;

select * from route_segments rs left join orders o
on rs.order_id = o.order_id
order by driver_id, segment_start_time asc;

alter table orders
add column total_delivery_time INT;

update orders o inner join(
    select 
        order_id,
        sum(timestampdiff(second, segment_start_time, segment_end_time)) as total_delivery_time
    from  route_segments
    where segment_type = 'STOP' and order_id IS NOT NULL
    group by order_id
) rs on o.order_id = rs.order_id
SET o.total_delivery_time = rs.total_delivery_time;

select * from orders;

select order_id from route_segments;

select order_id, planne_delivery_duration from orders;


