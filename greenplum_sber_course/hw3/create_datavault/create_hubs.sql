-- 1. Hub_Customer
       CREATE TABLE Hub_Customer (
        Customer_HashKey CHAR(32) PRIMARY KEY,
        CustomerID INTEGER NOT NULL,
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL
    );

    insert into Hub_Customer (Customer_HashKey, CustomerID, LoadDate, RecordSource)
    select md5(c_custkey::text),
        c_custkey,
        now(),
        '/tmp/datasets/customer.csv'
    from customer;
    
-- 2. Hub_Order
       CREATE TABLE Hub_Order (
        Order_HashKey CHAR(32) PRIMARY KEY,
        OrderID INTEGER NOT NULL,
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL
    );

    insert into Hub_Order (Order_HashKey, OrderID, LoadDate, RecordSource)
    select md5(O_ORDERKEY::text),
        O_ORDERKEY,
        now(),
        '/tmp/datasets/orders.csv'
    from orders;
    
-- 3. Hub_Supplier
       CREATE TABLE Hub_Supplier (
        Supplier_HashKey CHAR(32) PRIMARY KEY,
        SupplierID INTEGER NOT NULL,
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL
    );
    
    insert into Hub_Supplier (Supplier_HashKey, SupplierID, LoadDate, RecordSource)
    select md5(S_SUPPKEY::text),
        S_SUPPKEY,
        now(),
        '/tmp/datasets/supplier.csv'
    from supplier;

-- 4. Hub_Part
       CREATE TABLE Hub_Part (
        Part_HashKey CHAR(32) PRIMARY KEY,
        PartID INTEGER NOT NULL,
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL
    );

    insert into Hub_Part (Part_HashKey, PartID, LoadDate, RecordSource)
    select md5(P_PARTKEY::text),
        P_PARTKEY,
        now(),
        '/tmp/datasets/part.csv'
    from part;
    
-- 5. Hub_LineItem
       CREATE TABLE Hub_LineItem (
        LineItem_HashKey CHAR(32) PRIMARY KEY,
        LineItemID INTEGER NOT NULL,
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL
    );
    
    insert into Hub_LineItem (LineItem_HashKey, LineItemID, LoadDate, RecordSource)
    select md5(row(L_ORDERKEY, L_PARTKEY, L_SUPPKEY, L_LINENUMBER) ::text),
        L_LINENUMBER,
        now(),
        '/tmp/datasets/lineitem.csv'
    from lineitem;