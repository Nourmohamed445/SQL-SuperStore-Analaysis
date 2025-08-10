/*
You’ve split fLayer.superStore_raw into:

- Dimension-like tables:
  orders (OrderID, dates, ship mode)
  customers (CustomerID, name, segment)
  locations (Country, City, State, Postal Code, Region)
  products (ProductID, Category, SubCategory, ProductName)

- Fact-like table:
  sales (OrderID, ProductID, CustomerID, Sales, Quantity, Discount, Profit)
  That’s basically a bronze layer star schema — still raw values, but organized into separate entities.
*/
