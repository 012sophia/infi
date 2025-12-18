sqlite> select o.customerid,sum(od.quantity*p.price) sales from orders o 
join orderdetails od on o.orderid=od.orderid
 join products p on od.productid=p.productid group by o.customerid order by sales des
c limit 3;

Gesucht sind die CustomerID und der CustomerName aller Kunden,
die mindestens eine Bestellung aufgegeben haben.
Sortierung: CustomerName alphabetisch aufsteigend.
select distinct c.customerid ,c.customername from customers c join orders o on c.customerid=o.customerid order by c.customernam
e; 