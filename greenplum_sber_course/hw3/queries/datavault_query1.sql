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
    so.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_Order WHERE Order_HashKey = ho.Order_HashKey);