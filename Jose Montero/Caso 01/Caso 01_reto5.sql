select
	c.customer_id as Cliente
	, sum(coalesce(((case m.price
			when 10 then 20
			else m.price
		   end)*10),0)) as Punticos
from case01.sales v
left join case01.menu m
	on v.product_id=m.product_id
right join case01.customers c
	on v.customer_id=c.customer_id
group by c.customer_id
order by 1