select 
    c.c_custkey, 
    c.c_name,
    c.c_address,
    c.c_phone,
    o.o_orderkey,
    o.o_orderdate,
    l.l_shipdate
from customer c, orders o, lineitem l
where 
    c.c_custkey = o.o_custkey and o.o_orderkey = l.l_orderkey;

-- and c.c_name like 'Customer#000012761';