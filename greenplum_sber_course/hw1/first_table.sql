select now();



drop table public.customers cascade;

CREATE TABLE public.customers (
    customer_id SERIAL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(50),
    country VARCHAR(50)
)
distributed randomly;

select gp_segment_id, count() from public.customers group by gp_segment_id order by gp_segment_id;

INSERT INTO public.customers (first_name, last_name, email, phone, city, country)
SELECT
    'FirstName_' || gs AS first_name,
    'LastName_' || gs AS last_name,
    'user' || gs || '@example.com' AS email,
    '555-' || LPAD((FLOOR(RANDOM() * 10000))::TEXT, 4, '0') AS phone,
    CASE
        WHEN gs % 5 = 0 THEN 'New York'
        WHEN gs % 5 = 1 THEN 'Los Angeles'
        WHEN gs % 5 = 2 THEN 'Chicago'
        WHEN gs % 5 = 3 THEN 'Houston'
        ELSE 'Phoenix'
    END AS city,
    'USA' AS country
FROM generate_series(1, 10000) AS gs;