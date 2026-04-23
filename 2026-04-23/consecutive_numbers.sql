//180. Consecutive Numbers
CREATE TABLE logs (id INTEGER PRIMARY KEY, num INTEGER NOT NULL); INSERT INTO logs (id, num) VALUES (1,1),(2,1),(3,1),(4,2),(5,1),(6,2),(7,2);
select distinct a.num as consecutiveNums from logs a join logs b on a.id+1 = b.id join logs c on b.id+1=c.id where a.num=b.num and b.num=c.num;