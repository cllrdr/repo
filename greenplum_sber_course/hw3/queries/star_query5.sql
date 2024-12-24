select 
    s.s_suppkey,
    s.s_name,
    p.p_partkey,
    p.p_name,
    p.p_mfgr,
    p.p_retailprice
from supplier s, part p, partsupp ps
    where s.s_suppkey = ps.ps_suppkey and ps.ps_partkey = p.p_partkey
    and s.s_suppkey = 470;