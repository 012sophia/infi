sqlite> select o.customerid,sum(od.quantity*p.price) sales from orders o 
join orderdetails od on o.orderid=od.orderid
 join products p on od.productid=p.productid group by o.customerid order by sales des
c limit 3;
20|35631.21
51|23362.6
71|22500.06