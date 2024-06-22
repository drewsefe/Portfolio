-- 1. KPIs for Total Revenue, Profit, Number of Orders, Profit Margin
select *
from orders

select	ROUND(SUM(revenue),2) as total_revenue,
		ROUND(SUM(profit),2) as total_profit,
		COUNT(*) as total_orders,
		ROUND(SUM(profit)/SUM(revenue),2) * 100 as profit_margin
from orders

-- 2. Revenue, Profit, Profit Margin, and Number of Orders for each sport
select	sport,
		ROUND(SUM(revenue),2) as total_revenue,
		ROUND(SUM(profit),2) as total_profit,
		COUNT(*) as total_orders,
		ROUND(SUM(profit)/SUM(revenue),2) * 100 as profit_margin
from orders
group by sport
order by profit_margin desc

-- Number of customer ratings and the average rating
select
(select COUNT(*) from orders where rating is not null) as number_of_reviews,
ROUND(AVG(rating),0) as average_rating
from orders

--Each individual rating and it's revenue, profit and profit margin
select	rating,
		ROUND(SUM(revenue),2) as total_revenue,
		ROUND(SUM(profit),2) as total_profit,
		ROUND(SUM(profit)/SUM(revenue),2) * 100 as profit_margin
from orders
where rating is not null
group by rating
order by total_revenue DESC

-- State revenue, profit and profit margin
select c.state,	
		ROW_NUMBER() over(order by sum(o.revenue) desc) as revenue_rank,
		ROUND(SUM(o.revenue),2) as total_revenue,
		ROW_NUMBER() over(order by sum(o.profit) desc) as profit_rank,
		ROUND(SUM(o.profit),2) as total_profit,
		ROW_NUMBER() over(order by sum(o.profit)/sum(o.revenue) desc) as margin_rank,
		ROUND(SUM(o.profit)/SUM(o.revenue),2) * 100 as profit_margin
from orders o 
join customers c
on o.customer_id = c.customer_id
group by c.state
order by margin_rank

