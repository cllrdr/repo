CREATE INDEX title_bmp_idx ON films USING bitmap (title);



---список всех существующих классов операторов

SELECT am.amname AS index_method,
   opc.opcname AS opclass_name,
   opc.opcintype::regtype AS indexed_type,
   opc.opcdefault AS is_default
FROM pg_am am, pg_opclass opc
WHERE opc.opcmethod = am.oid
and am.amname = 'btree'
ORDER BY index_method, opclass_name;


---
drop database if exists test;

create database test;

drop table if exists test;
create table test as
select generate_series as id
	, generate_series::text || (random() * 10)::text as col2
    , (array['Yes', 'No', 'Maybe'])[floor(random() * 3 + 1)] as is_okay
from generate_series(1, 50000);

select * from test limit 10;

set optimizer=False;
analyse test;

explain
select * from test where id = 1;

analyse test;

explain analyze
delete from test where id = 1;

select * from test limit 10;

-- Sets the planner's estimate of the cost of a sequentially fetched disk page.
select * from pg_settings where name ='seq_page_cost';
-- Sets the planner's estimate of the cost of processing each tuple (row).
select * from pg_settings where name ='cpu_tuple_cost';


-----вычсиление cost-----

analyse test;

explain (buffers,analyse)
select *
from test;

--(число_чтений_диска * seq_page_cost) +
-- (число_просканированных_строк * cpu_tuple_cost)
show seq_page_cost;
show cpu_tuple_cost;
--(384*1)+(49999*0,01)

set seq_page_cost=2;
reset all;

----Смотрим планы выполнения в визуализаторах
explain
select id from test where id = 1;

-- https://explain.tensor.ru/

-- не использовать!!! https://explain.depesz.com/ 
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select id from test where id = 1;

EXPLAIN (ANALYZE, BUFFERS)
select id from test where id = 2;

CREATE INDEX CONCURRENTLY "~test-9fccd81c"
    ON test(id);

CREATE INDEX CONCURRENTLY "explain_depesz_com_hint_ORLQ_1"
    ON test ( id );

drop table if exists test;


--Уникальный индекс
drop table if exists test;

create table test as
select generate_series as id
	, generate_series::text || (random() * 10)::text as col2
    , (array['Yes', 'No', 'Maybe'])[floor(random() * 3 + 1)] as is_okay
from generate_series(1, 50000);

alter table test add constraint uk_test_id unique(id);

analyze test;

---width
explain analyze
select * from test where id is null;

explain
select id from test where id = 1;

insert into test values (null, 12, 'Yes');
insert into test values (null, 12, 'No');

delete from test where id is null;

explain
select * from test where id is null;

alter table test drop constraint uk_test_id;

create unique index idx_test_id on test(id) NULLS not DISTINCT;

explain
select * from test where id is null;

explain select *
from test
order by id desc;

drop table if exists test;



--Составной индекс
drop table if exists test;
create table test as
select generate_series as id
	, generate_series::text || (random() * 10)::text as col2
    , (array['Yes', 'No', 'Maybe'])[floor(random() * 3 + 1)] as is_okay
from generate_series(1, 50000);

drop index if exists idx_test_id;

create index idx_test_id_is_okay on test(id, is_okay);

-- будет ли здесь работать индекс?
explain
select * from test where id = 1 and is_okay = 'True';

-- а тут?
explain
select * from test where id = 1;

explain
select * from test where is_okay = 'True';

analyse test;

set enable_seqscan='on';
set enable_indexscan='off';

show enable_seqscan;
show enable_indexscan;

reset all;

explain analyse
select * from test where is_okay = 'Yes'; -- 5.054

create index idx_test_is_okay on test(is_okay);

explain
select * from test order by id, is_okay;

explain
select * from test order by id asc , is_okay desc;

set enable_seqscan='on';
SET enable_incremental_sort = on;


explain
select * from test order by id, is_okay desc;
drop table if exists test;


--индекс на функцию  ()
drop table if exists test;

create table test as
select generate_series as id
	, generate_series::text || (random() * 10)::text as col2
    , (array['Yes', 'No', 'Maybe'])[floor(random() * 3 + 1)] as is_okay
from generate_series(1, 50000);


create index idx_test_id_is_okay on test(lower(is_okay));

select * from test limit 10;

explain
select * from test where is_okay = 'Yes';

explain
select is_okay from test where lower(is_okay) = 'Yes';


--частичный индекс
drop table test;
create table test as
select generate_series as id
	, generate_series::text || (random() * 10)::text as col2
    , (array['Yes', 'No', 'Maybe'])[floor(random() * 3 + 1)] as is_okay
from generate_series(1, 50000);

create index idx_test_id_100 on test(id) where id < 100;

analyze test;

explain analyze
select * from test where id < 100;


--обслуживание индексов
SELECT
    TABLE_NAME,
    pg_size_pretty(table_size) AS table_size,
    pg_size_pretty(indexes_size) AS indexes_size,
    pg_size_pretty(total_size) AS total_size
FROM (
    SELECT
        TABLE_NAME,
        pg_table_size(TABLE_NAME) AS table_size,
        pg_indexes_size(TABLE_NAME) AS indexes_size,
        pg_total_relation_size(TABLE_NAME) AS total_size
    FROM (
        SELECT ('"' || table_schema || '"."' || TABLE_NAME || '"')
            AS TABLE_NAME
        FROM information_schema.tables
    ) AS all_tables
    ORDER BY total_size DESC
) AS pretty_sizes;

select * from pg_stat_user_indexes;



--неиспользуемые индексы
SELECT s.schemaname,
       s.relname AS tablename,
       s.indexrelname AS indexname,
       pg_size_pretty(pg_relation_size(s.indexrelid)) AS index_size,
       s.idx_scan
FROM pg_catalog.pg_stat_all_indexes s
   JOIN pg_catalog.pg_index i ON s.indexrelid = i.indexrelid
WHERE s.idx_scan < 100      -- has never been scanned
  AND 0 <>ALL (i.indkey)  -- no index column is an expression
  AND NOT i.indisunique   -- is not a UNIQUE index
  AND NOT EXISTS          -- does not enforce a constraint
         (SELECT 1 FROM pg_catalog.pg_constraint c
          WHERE c.conindid = s.indexrelid)
ORDER BY pg_relation_size(s.indexrelid) DESC;

SELECT
    tablename,
    indexname,
    indexdef
FROM
    pg_indexes
ORDER BY
    tablename,
    indexname;


--Индекс на timestamp (between)

drop table if exists orders;
create table orders (
    id int,
    user_id int,
    order_date date,
    status text,
    some_text text
);


insert into orders(id, user_id, order_date, status, some_text)
select generate_series,
       (random() * 70),
       date'2019-01-01' + (random() * 300)::int as order_date
        , (array['returned', 'completed', 'placed', 'shipped'])[(random() * 4)::int]
        , concat_ws(' ', (array['go', 'space', 'sun', 'London'])[(random() * 5)::int]
            , (array['the', 'capital', 'of', 'Great', 'Britain'])[(random() * 6)::int]
            , (array['some', 'another', 'example', 'with', 'words'])[(random() * 6)::int]
            )
from generate_series(1,1000000);

select * from orders limit 100;

insert into orders(id, user_id, order_date, status, some_text)
VALUES (0, 0, '2023-08-03', 'медвед', 'привет');

select *
from orders
order by id
limit 10;

--cost > jit_above_cost включается JIT
explain
select *
from orders
where id < 1000000;

set jit_above_cost = 10;
show jit_above_cost;

reset all;

select * from pg_settings
where name = 'jit_above_cost' limit 100;

drop index if exists idx_orders_id;
create index idx_orders_id on orders(some_text);

explain
select *
from orders
where id < 1500000;

explain analyse
select *
from orders
order by some_text;

explain
select *
from orders
order by id desc;

--Индекс на даты
drop index if exists idx_ord_order_Date;
create index idx_ord_order_Date on orders(order_date);
explain analyse
select *
from orders
where order_date between date'2019-01-01' and date'2019-02-01';


--Индекс include
drop index if exists idx_ord_order_date_inc_status_some_include;
create index idx_ord_order_date_inc_status_some_include
    on orders(order_date) include (status);

drop index idx_ord_order_date_status;
create index idx_ord_order_date_status
    on orders(order_date, status);

analyze orders;

drop index if exists idx_ord_order_date_inc_status;
create index idx_ord_order_date_inc_status
    on orders(status);
-- create index idx_ord_order_date_inc_status on orders;

drop index if exists idx_ord_order_date_inc_status_some_include;
create index idx_ord_order_date_inc_status_some_include
    on orders(status) include (some_text);

explain analyze
select order_date, status, some_text
from orders
where order_date between date'2019-01-01' and date'2019-02-01' and status = 'shipped';

set enable_seqscan = 'on';

explain analyze
select order_date, status
from orders
where status = 'shipped';


--Работа с лексемами
drop table if exists orders;
create table orders(
    id int,
    user_id int,
    order_date date,
    status text,
    some_text text
);

insert into orders(id, user_id, order_date, status, some_text)
select generate_series, (random() * 70), date'2019-01-01' + (random() * 300)::int as order_date
        , (array['returned', 'completed', 'placed', 'shipped'])[(random() * 4)::int]
        , concat_ws(' ', (array['go', 'space', 'sun', 'London'])[(random() * 5)::int]
            , (array['the', 'capital', 'of', 'Great', 'Britain'])[(random() * 6)::int]
            , (array['some', 'another', 'example', 'with', 'words'])[(random() * 6)::int]
            )
from generate_series(1,1000000);

select *
from orders
limit 100;

explain (analyse,buffers)
select * from orders where some_text ilike 'a%';

select some_text, to_tsvector(some_text)
from orders
limit 100;

explain analyse
select some_text,
       to_tsvector(some_text),
       to_tsvector(some_text) @@ to_tsquery('britains')
from orders
limit 100;

select some_text, to_tsvector(some_text) @@ to_tsquery('london & capital')
from orders
limit 100;

select some_text, to_tsvector(some_text) @@ to_tsquery('london | capital')
from orders
limit 100;

alter table orders drop column if exists some_text_lexeme;

alter table orders add column some_text_lexeme tsvector;

update orders
set some_text_lexeme = to_tsvector(some_text)
where 1=1;

analyse orders;

explain analyze
select *
from orders
where some_text_lexeme @@ to_tsquery('britains');

drop index if exists search_index_ord;

CREATE INDEX search_index_ord ON orders
    USING GIN (some_text_lexeme); -- 67 ms

CREATE INDEX search_index_ord_gist ON orders
    USING gist (some_text_lexeme); -- 210 ms

explain
select *
from orders
where some_text_lexeme @@ to_tsquery('britains');


--Расширения pgstattuple
CREATE EXTENSION pgstattuple;

drop table if exists orders;
create table orders (
    id int,
    user_id int,
    order_date date,
    status text,
    some_text text
);


insert into orders(id, user_id, order_date, status, some_text)
select generate_series, (random() * 70), date'2019-01-01' + (random() * 300)::int as order_date
        , (array['returned', 'completed', 'placed', 'shipped'])[(random() * 4)::int]
        , concat_ws(' ', (array['go', 'space', 'sun', 'London'])[(random() * 5)::int]
            , (array['the', 'capital', 'of', 'Great', 'Britain'])[(random() * 6)::int]
            , (array['some', 'another', 'example', 'with', 'words'])[(random() * 6)::int]
            )
from generate_series(1, 1000000);

select *
from orders
limit 100;

create index orders_order_date on orders(order_date);

analyse orders;

select * from pg_stat_user_tables where relname='orders';

select * from pgstattuple('orders');

select * from pgstatindex('orders_order_date');

update orders
set order_date='2021-11-01'
where id < 500000;

select * from pgstattuple('orders');

select * from pgstatindex('orders_order_date');

vacuum orders;

vacuum full orders;


--Кластеризация
drop table if exists orders;

create table orders (
    id int,
    user_id int,
    order_date date,
    status text,
    some_text text
);

insert into orders(id, user_id, order_date, status, some_text)
select generate_series, (random() * 70), date'2019-01-01' + (random() * 300)::int as order_date
        , (array['returned', 'completed', 'placed', 'shipped'])[(random() * 4)::int]
        , concat_ws(' ', (array['go', 'space', 'sun', 'London'])[(random() * 5)::int]
            , (array['the', 'capital', 'of', 'Great', 'Britain'])[(random() * 6)::int]
            , (array['some', 'another', 'example', 'with', 'words'])[(random() * 6)::int]
            )
from generate_series(1, 1000000);

select * from orders;

SET work_mem = '64MB';

explain
select * from orders where order_date = '2019-04-26';

drop index if exists order_date_idx;

create index order_date_idx on orders(order_date);

cluster orders using order_date_idx;

analyse orders;

select * from orders where order_date = '2019-04-26';