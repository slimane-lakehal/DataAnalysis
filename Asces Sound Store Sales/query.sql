WITH cte as (
		SELECT pd.[Product_ID]
					,pd.[Product]
					,pd.[Category]
					,pd.[Cost_Price]
					,pd.[Sale_Price]
					,pd.[Brand]
					,pd.[Description]
					,pd.[Image_url]
					,DATEFROMPARTS(            -- The date column is in year-month-day format
											YEAR(ps.Date),  -- Extract year
											DAY(ps.Date),   -- Treat the day as the month
											MONTH(ps.Date)  -- Treat the month as the day
								 ) as Date
					,ps.[Customer_Type]
					,ps.[Country]
					,ps.[Discount_Band]
					,ps.[Units_Sold]
					,(pd.Sale_Price * ps.Units_Sold) as revenue
					,(pd.Cost_Price * ps.Units_Sold) as total_cost
					,FORMAT(
								 DATEFROMPARTS(
										 YEAR(ps.Date),  
										 DAY(ps.Date),   
										 MONTH(ps.Date)
								 ), 
								 'MMMM', 'en-US') as month
					,FORMAT(ps.Date, 'yyyy') as year
		FROM dbo.Product_data pd
		JOIN dbo.Product_sales ps
		ON pd.Product_ID = ps.Product)


SELECT a.*,
	(1- discount*1.0/100) * revenue as Discount_Revenue,
	dc.Discount
FROM cte a
JOIN Discount_data dc
ON a.Discount_Band = dc.Discount_Band
AND a.month = dc.Month
