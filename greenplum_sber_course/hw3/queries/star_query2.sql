select 
    o.o_orderkey,
    o.o_orderdate,
    l.l_shipdate,
    l.l_linenumber,
    l.l_quantity,
    l.l_extendedprice,
    l.l_discount
from orders o, lineitem l 
    where o.o_orderkey = l.l_orderkey;