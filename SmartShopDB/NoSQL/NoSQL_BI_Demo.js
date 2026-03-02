// MongoDB shell script demonstrating BI-style queries on the NoSQL SmartShop dataset
// switch to the NoSQL database; use getSiblingDB for compatibility
if (typeof db !== 'undefined' && db.getSiblingDB) {
    db = db.getSiblingDB("SmartShopNoSQL");
} else {
    // when running under mongo shell, the `use` command works
    // (uncomment the next line if needed)
    // use SmartShopNoSQL;
}

// 1. Top-selling products by quantity
print("=== Top-selling products (by quantity) ===");
db.orders.aggregate([
    { $unwind: "$items" },
    { $group: { _id: "$items.productId", quantitySold: { $sum: "$items.qty" },
                salesAmount: { $sum: { $multiply: ["$items.qty", "$items.unitPrice"] } } } },
    { $lookup: { from: "products", localField: "_id", foreignField: "_id", as: "product" } },
    { $unwind: "$product" },
    { $project: { _id: 0, productName: "$product.name", quantitySold: 1, salesAmount: 1 } },
    { $sort: { quantitySold: -1 } }
]).forEach(printjson);

// 2. Monthly sales per branch
print("\n=== Monthly sales per branch ===");
db.orders.aggregate([
    { $group: { _id: { branchId: "$branchId", month: { $dateToString: { format: "%Y-%m", date: "$orderDate" } } },
                totalSales: { $sum: "$totalAmount" } } },
    { $lookup: { from: "branches", localField: "_id.branchId", foreignField: "_id", as: "branch" } },
    { $unwind: "$branch" },
    { $project: { _id: 0, branchName: "$branch.branchName", month: "$_id.month", totalSales: 1 } },
    { $sort: { branchName: 1, month: 1 } }
]).forEach(printjson);

// 3. Customer spend summary
print("\n=== Customer spend summary ===");
db.orders.aggregate([
    { $group: { _id: "$customerId", numberOfOrders: { $sum: 1 }, totalSpent: { $sum: "$totalAmount" } } },
    { $lookup: { from: "customers", localField: "_id", foreignField: "_id", as: "customer" } },
    { $unwind: "$customer" },
    { $project: { _id: 0, customer: { $concat: ["$customer.firstName", " ", "$customer.lastName"] }, numberOfOrders: 1, totalSpent: 1 } },
    { $sort: { totalSpent: -1 } }
]).forEach(printjson);

// 4. Orders in the last 7 days
print("\n=== Orders in the last 7 days ===");
db.orders.find({ orderDate: { $gte: new Date(new Date().getTime() - 7*24*60*60*1000) } })
    .sort({ orderDate: -1 })
    .forEach(printjson);

// 5. Product sales per category
print("\n=== Product sales per category ===");
db.orders.aggregate([
    { $unwind: "$items" },
    { $lookup: { from: "products", localField: "items.productId", foreignField: "_id", as: "product" } },
    { $unwind: "$product" },
    { $group: { _id: "$product.category", totalQuantity: { $sum: "$items.qty" },
                totalSales: { $sum: { $multiply: ["$items.qty", "$items.unitPrice"] } } } },
    { $sort: { totalSales: -1 } }
]).forEach(printjson);
