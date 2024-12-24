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
        '/tmp/datasets/customers'
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
        '/tmp/datasets/orders.csv'
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
        '/tmp/datasets/supplier.csv'
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
        '/tmp/datasets/part.csv'
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
        md5(row(L_ORDERKEY, L_PARTKEY, L_SUPPKEY, L_LINENUMBER) ::text) AS LineItem_HashKey,
        l_quantity AS Quantity,
        l_extendedprice AS Price,
        l_discount AS Discount,
        now(),
        '/tmp/datasets/lineitem.csv'
    FROM LINEITEM;
