-- Creating a Data Vault architecture for the TPC-H dataset in 
--     Greenplum involves defining Hubs, Links, and Satellites. 
--     Below is the DDL (Data Definition Language) for such a setup.

-- ### Hubs
-- Hubs store the unique business keys and provide the primary means of linking data together.

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
        'source_hw2' -- '/tmp/datasets/customer.csv'
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
        'source_hw2' -- '/tmp/datasets/orders.csv'
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
        'source_hw2' -- '/tmp/datasets/supplier.csv'
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
        'source_hw2' -- '/tmp/datasets/part.csv'
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
        'source_hw2' -- '/tmp/datasets/lineitem.csv'
    from lineitem;


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
        'source_hw2' -- '/tmp/datasets/orders.csv'
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
        MD5(CAST(l_linenumber AS TEXT)) AS LineItem_HashKey,
        now(),
        'source_hw2' -- '/tmp/datasets/lineitem.csv'
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
    

-- ### Satellites
-- Satellites store the descriptive data related to business keys or relationships.

-- 1. Satellite_Customer
       CREATE TABLE Satellite_Customer (
        Customer_HashKey CHAR(32) NOT NULL,
        CustomerName VARCHAR(50),
        CustomerAddress VARCHAR(100),
        CustomerPhone VARCHAR(20),
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL,
        CONSTRAINT fk_customer FOREIGN KEY (Customer_HashKey) REFERENCES Hub_Customer(Customer_HashKey)
    );

    INSERT INTO Satellite_Customer (Customer_HashKey, CustomerName, CustomerAddress, CustomerPhone, LoadDate, RecordSource)
    SELECT 
        MD5(CAST(c_custkey AS TEXT)) AS Customer_HashKey,
        c_name AS CustomerName,
        c_address AS CustomerAddress,
        c_phone AS CustomerPhone,
        now(),
        'source_hw2'
    FROM CUSTOMER;
    
-- 2. Satellite_Order
       CREATE TABLE Satellite_Order (
        Order_HashKey CHAR(32) NOT NULL,
        OrderDate DATE,
        ShipDate DATE,
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL,
        CONSTRAINT fk_order FOREIGN KEY (Order_HashKey) REFERENCES Hub_Order(Order_HashKey)
    );

    INSERT INTO Satellite_Order (Order_HashKey, OrderDate, ShipDate, LoadDate, RecordSource)
    SELECT 
        MD5(CAST(o_orderkey AS TEXT)) AS Order_HashKey,
        o_orderdate AS OrderDate,
        o_orderdate + interval '1 month' AS ShipDate,
        now(),
        'source_hw2' -- '/tmp/datasets/orders.csv'
    FROM ORDERS;
    
-- 3. Satellite_Supplier
       CREATE TABLE Satellite_Supplier (
        Supplier_HashKey CHAR(32) NOT NULL,
        SupplierName VARCHAR(50),
        SupplierAddress VARCHAR(100),
        SupplierPhone VARCHAR(20),
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL,
        CONSTRAINT fk_supplier FOREIGN KEY (Supplier_HashKey) REFERENCES Hub_Supplier(Supplier_HashKey)
    );

    INSERT INTO Satellite_Supplier (Supplier_HashKey, SupplierName, SupplierAddress, SupplierPhone, LoadDate, RecordSource)
    SELECT 
        MD5(CAST(s_suppkey AS TEXT)) AS Supplier_HashKey,
        s_name AS SupplierName,
        s_address AS SupplierAddress,
        s_phone AS SupplierPhone,
        now(),
        'source_hw2' -- '/tmp/datasets/supplier.csv'
    FROM SUPPLIER;
    
-- 4. Satellite_Part
       CREATE TABLE Satellite_Part (
        Part_HashKey CHAR(32) NOT NULL,
        PartName VARCHAR(50),
        PartDescription VARCHAR(200),
        PartPrice DECIMAL(10, 2),
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL,
        CONSTRAINT fk_part FOREIGN KEY (Part_HashKey) REFERENCES Hub_Part(Part_HashKey)
    );

    INSERT INTO Satellite_Part (Part_HashKey, PartName, PartDescription, PartPrice, LoadDate, RecordSource)
    SELECT 
        MD5(CAST(p_partkey AS TEXT)) AS Part_HashKey,
        p_name::VARCHAR(50) AS PartName,
        p_mfgr AS PartDescription,
        p_retailprice AS PartPrice,
        now(),
        'source_hw2' -- '/tmp/datasets/part.csv'
    FROM PART;
    
-- 5. Satellite_LineItem
       CREATE TABLE Satellite_LineItem (
        LineItem_HashKey CHAR(32) NOT NULL,
        Quantity INTEGER,
        Price DECIMAL(10, 2),
        Discount DECIMAL(5, 2),
        LoadDate TIMESTAMP NOT NULL,
        RecordSource VARCHAR(50) NOT NULL,
        CONSTRAINT fk_lineitem FOREIGN KEY (LineItem_HashKey) REFERENCES Hub_LineItem(LineItem_HashKey)
    );

    INSERT INTO Satellite_LineItem (LineItem_HashKey, Quantity, Price, Discount, LoadDate, RecordSource)
    SELECT 
        MD5(CAST(l_linenumber AS TEXT)) AS LineItem_HashKey,
        l_quantity AS Quantity,
        l_extendedprice AS Price,
        l_discount AS Discount,
        now(),
        'source_hw2' -- '/tmp/datasets/lineitem.csv'
    FROM LINEITEM;
    

-- ### Notes
-- 1. Hash Keys: The CHAR(32) columns are placeholders for the actual hash keys generated from the business keys using a 
--     hash function like MD5.
-- 2. LoadDate: Captures the date and time when the record was loaded into the Data Vault.
-- 3. RecordSource: Identifies the source system of the data.
-- 4. Foreign Keys: Ensure referential integrity between hubs, links, and satellites.

-- These queries demonstrate how to join Hubs, Links, and Satellites to retrieve comprehensive information 
--     from the Data Vault architecture.

-- ### Query 1: Retrieve Customer Orders with Order and Customer Details

SELECT 
    hc.CustomerID,
    sc.CustomerName,
    sc.CustomerAddress,
    sc.CustomerPhone,
    ho.OrderID,
    so.OrderDate,
    so.ShipDate
FROM 
    Hub_Customer hc
JOIN 
    Link_Customer_Order lco ON hc.Customer_HashKey = lco.Customer_HashKey
JOIN 
    Hub_Order ho ON lco.Order_HashKey = ho.Order_HashKey
JOIN 
    Satellite_Customer sc ON hc.Customer_HashKey = sc.Customer_HashKey
JOIN 
    Satellite_Order so ON ho.Order_HashKey = so.Order_HashKey
WHERE 
    sc.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_Customer WHERE Customer_HashKey = hc.Customer_HashKey)
AND 
    so.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_Order WHERE Order_HashKey = ho.Order_HashKey)



-- ### Query 2: Retrieve Detailed Order Information with Line Items

SELECT 
    ho.OrderID,
    so.OrderDate,
    so.ShipDate,
    hl.LineItemID,
    sl.Quantity,
    sl.Price,
    sl.Discount
FROM 
    Hub_Order ho
JOIN 
    Link_Order_LineItem lol ON ho.Order_HashKey = lol.Order_HashKey
JOIN 
    Hub_LineItem hl ON lol.LineItem_HashKey = hl.LineItem_HashKey
JOIN 
    Satellite_Order so ON ho.Order_HashKey = so.Order_HashKey
JOIN 
    Satellite_LineItem sl ON hl.LineItem_HashKey = sl.LineItem_HashKey
WHERE 
    so.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_Order WHERE Order_HashKey = ho.Order_HashKey)
AND 
    sl.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_LineItem WHERE LineItem_HashKey = hl.LineItem_HashKey)



-- ### Query 3: Retrieve Supplier and Part Information for Each Supplier-Part Relationship


SELECT 
    hs.SupplierID,
    ss.SupplierName,
    ss.SupplierAddress,
    ss.SupplierPhone,
    hp.PartID,
    sp.PartName,
    sp.PartDescription,
    sp.PartPrice
FROM 
    Hub_Supplier hs
JOIN 
    Link_Supplier_Part lsp ON hs.Supplier_HashKey = lsp.Supplier_HashKey
JOIN 
    Hub_Part hp ON lsp.Part_HashKey = hp.Part_HashKey
JOIN 
    Satellite_Supplier ss ON hs.Supplier_HashKey = ss.Supplier_HashKey
JOIN 
    Satellite_Part sp ON hp.Part_HashKey = sp.Part_HashKey
WHERE 
    ss.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_Supplier WHERE Supplier_HashKey = hs.Supplier_HashKey)
AND 
    sp.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_Part WHERE Part_HashKey = hp.Part_HashKey)



-- ### Query 4: Retrieve Comprehensive Customer Order and Line Item Details


SELECT 
    hc.CustomerID,
    sc.CustomerName,
    ho.OrderID,
    so.OrderDate,
    so.ShipDate,
    hl.LineItemID,
    sl.Quantity,
    sl.Price,
    sl.Discount
FROM 
    Hub_Customer hc
JOIN 
    Link_Customer_Order lco ON hc.Customer_HashKey = lco.Customer_HashKey
JOIN 
    Hub_Order ho ON lco.Order_HashKey = ho.Order_HashKey
JOIN 
    Link_Order_LineItem lol ON ho.Order_HashKey = lol.Order_HashKey
JOIN 
    Hub_LineItem hl ON lol.LineItem_HashKey = hl.LineItem_HashKey
JOIN 
    Satellite_Customer sc ON hc.Customer_HashKey = sc.Customer_HashKey
JOIN 
    Satellite_Order so ON ho.Order_HashKey = so.Order_HashKey
JOIN 
    Satellite_LineItem sl ON hl.LineItem_HashKey = sl.LineItem_HashKey
WHERE 
    sc.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_Customer WHERE Customer_HashKey = hc.Customer_HashKey)
AND 
    so.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_Order WHERE Order_HashKey = ho.Order_HashKey)
AND 
    sl.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_LineItem WHERE LineItem_HashKey = hl.LineItem_HashKey)



-- ### Query 5: Retrieve All Parts Supplied by a Specific Supplier with Supplier Details


SELECT 
    hs.SupplierID,
    ss.SupplierName,
    hp.PartID,
    sp.PartName,
    sp.PartDescription,
    sp.PartPrice
FROM 
    Hub_Supplier hs
JOIN 
    Link_Supplier_Part lsp ON hs.Supplier_HashKey = lsp.Supplier_HashKey
JOIN 
    Hub_Part hp ON lsp.Part_HashKey = hp.Part_HashKey
JOIN 
    Satellite_Supplier ss ON hs.Supplier_HashKey = ss.Supplier_HashKey
JOIN 
    Satellite_Part sp ON hp.Part_HashKey = sp.Part_HashKey
WHERE 
    hs.SupplierID = 470 -- Replace 123 with the actual SupplierID
AND 
    ss.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_Supplier WHERE Supplier_HashKey = hs.Supplier_HashKey)
AND 
    sp.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_Part WHERE Part_HashKey = hp.Part_HashKey)



-- These queries leverage the Data Vault principles to join Hubs, Links, and Satellites efficiently, 
--     providing comprehensive and up-to-date information from the TPC-H dataset. 