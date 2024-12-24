select 
    c.c_custkey, 
    c.c_name,
    o.o_orderkey,
    o.o_orderdate,
    l.l_shipdate,
    l.l_linenumber,
    l.l_quantity,
    l.l_extendedprice,
    l.l_discount
from customer c, orders o, lineitem l
where 
    c.c_custkey = o.o_custkey and o.o_orderkey = l.l_orderkey;