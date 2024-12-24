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
    sl.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_LineItem WHERE LineItem_HashKey = hl.LineItem_HashKey);