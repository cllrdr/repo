-- ### Links
-- Links store the relationships between business keys.

-- 1. Link_Customer_Order
       CREATE TABLE Link_Customer_Order (
        Link_HashKey CHAR(32) PRIMARY KEY,
        Customer_HashKey CHAR(32) NOT NULL,
        Order_HashKey CHAR(32) NOT NULL,
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL,
        CONSTRAINT fk_customer FOREIGN KEY (Customer_HashKey) REFERENCES Hub_Customer(Customer_HashKey),
        CONSTRAINT fk_order FOREIGN KEY (Order_HashKey) REFERENCES Hub_Order(Order_HashKey)
    );

    insert into Link_Customer_Order (
        Link_HashKey, Customer_HashKey, Order_HashKey,
        LoadDate, RecordSource
    )
    select MD5(CONCAT(MD5(CAST(o_custkey AS TEXT)), MD5(CAST(o_orderkey AS TEXT)))) AS Link_HashKey,
        MD5(CAST(o_custkey AS TEXT)) AS Customer_HashKey,
        MD5(CAST(o_orderkey AS TEXT)) AS Order_HashKey,
        now(),
        'source_hw2'
    from orders;
    
-- 2. Link_Order_LineItem
       CREATE TABLE Link_Order_LineItem (
        Link_HashKey CHAR(32) PRIMARY KEY,
        Order_HashKey CHAR(32) NOT NULL,
        LineItem_HashKey CHAR(32) NOT NULL,
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL,
        CONSTRAINT fk_order FOREIGN KEY (Order_HashKey) REFERENCES Hub_Order(Order_HashKey),
        CONSTRAINT fk_lineitem FOREIGN KEY (LineItem_HashKey) REFERENCES Hub_LineItem(LineItem_HashKey)
    );

    insert into Link_Order_LineItem (
        Link_HashKey, Order_HashKey, LineItem_HashKey,
        LoadDate, RecordSource
    )
    select MD5(CONCAT(MD5(CAST(l_orderkey AS TEXT)), MD5(CAST(l_linenumber AS TEXT)))) AS Link_HashKey,
        MD5(CAST(l_orderkey AS TEXT)) AS Order_HashKey,
        md5(row(L_ORDERKEY, L_PARTKEY, L_SUPPKEY, L_LINENUMBER) ::text) AS LineItem_HashKey,
        now(),
        'source_hw2'
    from LINEITEM;
    
-- 3. Link_Supplier_Part
       CREATE TABLE Link_Supplier_Part (
        Link_HashKey CHAR(32) PRIMARY KEY,
        Supplier_HashKey CHAR(32) NOT NULL,
        Part_HashKey CHAR(32) NOT NULL,
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL,
        CONSTRAINT fk_supplier FOREIGN KEY (Supplier_HashKey) REFERENCES Hub_Supplier(Supplier_HashKey),
        CONSTRAINT fk_part FOREIGN KEY (Part_HashKey) REFERENCES Hub_Part(Part_HashKey)
    );

    insert into Link_Supplier_Part (
        Link_HashKey, Supplier_HashKey, Part_HashKey,
        LoadDate, RecordSource
    )
    select MD5(CONCAT(MD5(CAST(ps_suppkey AS TEXT)), MD5(CAST(ps_partkey AS TEXT)))) AS Link_HashKey,
        MD5(CAST(ps_suppkey AS TEXT)) AS Supplier_HashKey,
        MD5(CAST(ps_partkey AS TEXT)) AS Part_HashKey,
        now(),
        'source_hw2'
    from PARTSUPP;
