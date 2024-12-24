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
    sp.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_Part WHERE Part_HashKey = hp.Part_HashKey);