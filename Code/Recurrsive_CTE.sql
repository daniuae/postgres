-- CTE to merge new and existing inventory data
WITH MergedInventory AS (
    SELECT ni.ProductID, ni.Quantity AS NewQuantity, i.Quantity AS CurrentQuantity
    FROM NewInventoryData ni
    -- Use LEFT JOIN to include all new data, even if not in current inventory
    LEFT JOIN Inventory i ON ni.ProductID = i.ProductID
)
-- Merge the prepared data into the Inventory table
MERGE INTO Inventory AS i
USING MergedInventory AS mi
ON i.ProductID = mi.ProductID
-- Update existing products with new quantities
WHEN MATCHED THEN
    UPDATE SET i.Quantity = mi.NewQuantity
-- Insert new products if they don't exist in the inventory
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, Quantity) VALUES (mi.ProductID, mi.NewQuantity);




/*Recurrsive CTE*/

