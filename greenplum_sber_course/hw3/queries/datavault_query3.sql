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
    sp.LoadDate = (SELECT MAX(LoadDate) FROM Satellite_Part WHERE Part_HashKey = hp.Part_HashKey);