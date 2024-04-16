-- CREATING DATABASE

create database E_Commerce;
use E_Commerce;

-- IMPORTING THE TABLES

select * from `list of orders`;
select * from `order details`;
select * from `sales target`;

-- RENAMING THE TABLES

rename table `list of orders` to Order_List;
rename table `order details` to Order_Details;
rename table `sales target` to Sales_Target;

select * from Order_List;
select * from Order_Details;
select * from Sales_Target;

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# PRE-PROCESSING OF DATA.

-- CHANGING THE DATA TYPE OF THE COLUMN BY CREATING A NEW TABLE 

alter table  Order_List
add column Order_Date DATETIME;

update Order_List
set Order_Date = STR_TO_DATE(COALESCE(`Order Date`, '0000-00-00'), '%d-%m-%Y')
where `Order Date` is not null and  `Order Date` != '';

-- DROPING THE COLUMN WHICH HAS BEEN ALTERED AND UPDATED

alter table  Order_List
drop column `Order Date`;

-- CHECKING THE NULL VALUES FROM THE DATASET

select * from Order_List where Order_Date is null;
select * from Order_List where `Order ID` is null;
select * from Order_List where CustomerName is null;
select * from Order_List where State is null;
select * from Order_List where City is null;

-- DROPING THE NULL VALUES

delete from Order_List where Order_Date is null;


-- EXTRACTING YEAR, MONTH, DAY FROM THE ORDER DATE

alter table Order_List
add column Order_Year int,
add column Order_Month int,
add column Order_Day int;
alter table  Order_List
modify column Order_Month varchar(20);

update Order_List set 
Order_Year=extract(year from Order_Date);

update Order_List
set Order_Month = MONTH(Order_Date);
update Order_List 
set Order_Month=monthname(Order_Date);

update Order_List set
    Order_Day = EXTRACT(day from Order_Date);
    
select
  Order_Date,
  EXTRACT(year from Order_date) as year,
  EXTRACT(month from Order_Date) as month,
  MONTHNAME(Order_Date) as month_name, 
  EXTRACT(day from Order_Date) AS day from Order_List;

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#

select * from Order_List;

select customername
from Order_List
where State = 'Gujarat';

select
    Order_Year,
    COUNT(*) as Total_Orders
from 
    Order_List
group by 
    Order_Year; 
    
# INSIGHT:- * Trend Analysis: By analyzing the total number of orders per year over multiple years, patterns or trends may emerge.
#           * Seasonal Variations: Examining the distribution of orders across different seasons within each year can reveal whether there are certain times 
#             of the year.
#           * Overall, extracting the total number of orders per year provides valuable insights into various aspects of business performance, enabling informed 
#             decision-making and strategic planning.

select 
    Order_Year,
    Order_Month,
    COUNT(*) AS Total_Orders
from 
    Order_List
where 
    Order_Year = '2018'  -- Change to the desired year
group by
    Order_Year,
    Order_Month;

# INSIGHT:- By comparing monthly data across different years or against predefined targets, organizations can evaluate their growth, efficiency, and overall success.


# QUESTION:- IT EXTRACT THE TOTAL NUMBER OF ORDERS PER STATE.
select 
    State,
    COUNT(*) as Total_Orders
from 
    Order_List
group by 
    State;
    
# INSIGHT:- It can help identifying regions with high or low volumes,enabling businesses to tailor their strategies accordingly such as focusing marketing efforts 
#           in high-order states or optimizing logistics in low order states.


# QUESTION:- IT EXTRACT THE TOTAL NUMBER OF ORDERS PER CITY.
select 
    City,
    COUNT(*) as Total_Orders
from 
    Order_List
group by 
    City;
    
# INSIGHT:- It helps to identify cities with high order volumes, potentially indicating areas of strong cuatomer demand on strategic importance for business operations.


# QUESTION:- IT EXTRACTS TOP 10 CUSTOMERS WITH THE HIGHEST NUMBER OF OREDRS.

select 
    customername,
    COUNT(*) as Total_Orders
from
    Order_List
group by 
    customername
order by 
    Total_Orders desc
limit 10;

# INSIGHT:- The comapny is focusing on identifying its top customers base don the frequency of orders they place.


# QUESTION:-  IT EXTARCT THE NUMBER OF ORDERS PER DAY OF THE WEEK

select 
    DAYNAME(Order_Date) as Day_of_Week,
    COUNT(*) as Total_Orders
from 
    Order_List
group by 
    Day_of_Week;
    
# INSIGHT:- Understanding peak days of the week for order placements, which can inform resources allocation and straffing schedules.


# QUESTION:- IT EXTRACT NUMBER OF ORDERS OVER TIME(MONTHLY TREND)

select
    CONCAT(Order_Year, '-', Order_Month) as Years_Months,
    COUNT(*) as Total_Orders
from
    Order_List
group by
    Order_Year, Order_Month
order by 
    Order_Year, Order_Month;

# INSIGHT:- Comparing monthly trends year over year to assess overall business performance and identifying areas for improvement or expression.

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# QUESTION:- IT EXTRACT TOTAL SALES AMOUNT PER CATEGORY.

select * from Order_Details;

select
    Category,
    SUM(Amount) as Total_Sales_Amount
from  
    Order_Details
group by 
    Category;
    
# INSIGHT:- Identifying the most profitable product categories, which can guide inventory management and marketing strategies.
    
 
 # QUESTION:- IT EXTRACT TOTAL PROFIT PER CATEGORY.
 
select 
    Category,
    SUM(Profit) as Total_Profit
from 
    Order_Details
group by 
    Category;
    
 # INSIGHT:- Evaluating the contribution of each category to the overall profitability of the business, informing investment priorities and resources allocation.
 
 
 # QUESTION:-IT EXTRACT TOTAL QUANTITY SOLD PER CATEGORY. 
 
select
    Category,
    SUM(Quantity) as Total_Quantity_Sold
from 
    Order_Details
group by
    Category;
    
# INSIGHT:- It could help businesses understand which category are more popular enabling them to make informed decisions about inventory management.  
  
  
# QUESTION:- IT EXTRACT TOTAL SALES AMOUNT AND PROFIT PER SUB-CATEGORY. 
  
select 
    `Sub-Category`,
    SUM(Amount) as Total_Sales_Amount,
    SUM(Profit) as Total_Profit
from 
    Order_Details
group by  
    `Sub-Category`;

# INSIGHT:- It enables them to identify which subcategories are the most lucrative and where adjustments may be needed to improve profitability.


# QUESTION:- IT EXTRACTS TOP 5 CATEGORIES BY TOTAL SALES AMOUNT.

select 
    Category,
    SUM(Amount) as Total_Sales_Amount
from 
    Order_Details
group by 
    Category
order by 
    Total_Sales_Amount desc
limit 5;

# INSIGHT:- It is valuable for understanding which product categories contribute the most to overall renvenue and can inform strategic decisions such as resouce allocation,
#           marketing efforts, and inventory management.


# QUESTION:- CATEGORIES WITH THE HIGHEST AVERAGE PROFIT.

select 
    Category,
    avg(Profit) as Average_Profit
from 
    Order_Details
group by 
    Category
order by
    Average_Profit desc;

# INSIGHT:- By understanding which categories yield the highest average profits, companies can allocate resources more effectively.


# QUESTION:- IT EXTRACTS CATEGORIES WITH THE HIGHEST AVERAGE PROFIT MARGIN(PROFIT/AMOUNT).

select 
    Category,
    avg(Profit / Amount) as Average_Profit_Margin
from  
    Order_Details
group by
    Category
order by 
    Average_Profit_Margin desc;
   
# INSIGHT:- By understanding which categories yield the highest average profits margins, companies can allocate resources more effectively.


# QUESTION:-  TOP 5 SUB-CATEGORIES BY TOTAL QUANTITY SOLD.

select
   `Sub-Category`,
    SUM(Quantity) as Total_Quantity_Sold
from
    Order_Details
group by
    `Sub-Category`
order by
    Total_Quantity_Sold desc
limit 5;

# INSIGHT:- It is valuable for understanding consumer preferneces and demand patterns at a more granular level within each category.

#------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------------------------------------------------------------------------------------#

select * from Sales_Target;

alter table Sales_Target
add column Order_Year int,
add column Order_Month int;

alter table  Sales_Target
modify column Order_Month varchar(20);

update Sales_Target
set Order_Year = EXTRACT(year from STR_TO_DATE(CONCAT('01-', `Month of order Date`), '%d-%b-%y'));

update Sales_Target
set Order_Month = month(STR_TO_DATE(CONCAT('01-', `Month of order Date`), '%d-%b-%y'));

UPDATE Sales_Target
SET Order_Month = MONTHNAME(STR_TO_DATE(CONCAT('01-', `Month of order Date`), '%d-%b-%y'));

alter table  Sales_target
drop column `Month of order date`;


# QUESTION:- IT EXTRACTS TOTAL SALES PER CATEGORY.

select 
    Category,
    SUM(Target) as Total_Sales_Target
from 
    Sales_target
group by 
    Category;
    
# INSIGHT:- It is valuable for understanding the revenue contribution of different product categories to the overall business.


# QUESTION:- IT EXTRACTS TOTAL SALES PER CATEGORY

select  
    Category,
    avg(Target) as Average_Sales_Target
from
    Sales_Target
group by 
    Category;
    
# INSIGHTS:- This insight allows businesses to identify which categories are the primary revenue drivers and allocate resources accordingly.

# QUESTION:- IT EXTRACTS TOTAL SALES TARGET PER YEAR

select 
    Order_Year,
    SUM(Target) as Total_Sales_Target
from 
    Sales_Target
group by 
    Order_Year;
    
# INSIGHTS:- This insights enables businesses to set realistic targets, allocate resources effectively and measure performance against predetermined objectives.

# QUESTION:- IT EXTRACTS TOTAL SALES TARGET PER MONTH ACROSS ALL YEARS

select 
    Order_Month,
    SUM(Target) as Total_Sales_Target
from
    Sales_Target
group by 
    Order_Month;
    
# INSIGHTS:- This insight allows businesses to analyse seasonal variations identify peak months and assess overall sales patterns.


# QUESTION:- IT EXTRACTS TOTAL SALES TARGET PER CATEGORY FOR A SPECIFIC YEAR

select  
    Category,
    SUM(Target) as Total_Sales_Target
from 
    Sales_Target
where 
    Order_Year = 2018  -- Change to the desired year
group by 
    Category;
    
# INSIGHTS:- It allows businesses to evaluate the sales targets set for each category and compare them against actual sales performance.


# QUESTION:- IT EXTRACTS TOTAL SALES TARGET TREND OVEWR THE YEARS FOR A SPECIFIC CATEGORY

select
    Order_Year,
    SUM(Target) as Total_Sales_Target
from
    Sales_Target
where 
    Category = 'Furniture'  -- Change to the desired category
group by 
    Order_Year;
    
# INSIGHTS:- This insight  allows businesses to benchmark their performance against historical targets and industry norms providing valuable context for evaluating success.


# QUESTION:- IT EXTRACTS TOTAL SALES TARGET PER CATEGORY FOR EACH MONTH

select
    Category,
    Order_Month,
    SUM(Target) as Total_Sales_Target
from 
    Sales_Target
group by
    Category,
    Order_Month;
    
# INSIGHTS:- It allows businesses to track progress towards goals, identify seasonality patterns and adjust strategies accordingly.

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# QUESTION:- TOTAL SALES AMOUNT PER CUSTOMER FOR EACH MONTH

select 
    ol.CustomerName,
    ol.Order_Year,
    ol.Order_Month,
    SUM(od.Amount) as Total_Sales_Amount
from
    Order_List ol
join
    Order_Details od on ol.`Order ID` = od.`Order ID`
group by 
    ol.CustomerName,
    ol.Order_Year,
    ol.Order_Month;

# INSIGHT:-  It identifies seasonal patterns or fluctuations in demand, and asses the impact of marketing iniiatives or external factors.


# QUESTION:- TOTAL PROFIT PER CATEGORY FOR EACH YEAR.

select 
    ol.Order_Year,
    od.Category,
    SUM(od.Profit) as Total_Profit
from 
    Order_List ol
join 
    Order_Details od on ol.`Order ID` = od.`Order ID`
group by
    ol.Order_Year,
    od.Category;
    
# INSIGHT:- It evaluates the effectiveness of pricing strategies, cost management initiatives, and product development efforts.


# QUESTION:- TOP 5 CITIES WITH THE HIGHEST TOTAL SALES AMOUNT.

select 
    ol.City,
    SUM(od.Amount) as Total_Sales_Amount
from
    Order_List ol
join 
    Order_Details od on ol.`Order ID` = od.`Order ID`
group by 
    ol.City
order by  
    Total_Sales_Amount desc
limit 5;

# INSIGHT:- It allows businesses to identify key market areas where sales are strongest, understand regional preferences or demand patterns, allocate resources effectively.


# QUESTION:- TOTAL SALES AMOUNT FOR EACH MONTH AND CATEGORY

select  
    ol.Order_Year,
    ol.Order_Month,
    od.Category,
    SUM(od.Amount) as Total_Sales_Amount
from 
    Order_List ol
join 
    Order_Details od on ol.`Order ID` = od.`Order ID`
group by 
    ol.Order_Year,
    ol.Order_Month,
    od.Category;

# INSIGHT:-  Identifying the most profitable product categories, which can guide inventory management and marketing strategies.

# QUESTION:- TOTAL SALES AMOUNT FOR EACH CATEGORY AND SUB-CATEGORY.

select 
    od.Category,
    od.`Sub-Category`,
    SUM(od.Amount) as Total_Sales_Amount
from
    Order_Details od
group by 
    od.Category,
    od.`Sub-Category`;
    
# INSIGHT:- It can pinpoint areas of strength and opportunities for growth optimize product offerings and tailor marketing efforts to spwcific customer preferences.

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# QUESTION:- TOTAL SALES AMOUNT PER CUSTOMER.

select 
    CustomerName,
    (
        select SUM(Amount) 
        from Order_Details 
        where `Order ID` in (select `Order ID` from Order_List where CustomerName = ol.CustomerName)
    ) as Total_Sales_Amount
from 
    Order_List ol
group by 
    CustomerName;

# INSIGHT:- It helps in identifying high value customers and enhance customer relationship management efforts.


# QUESTION:- TOTAL PROFIT PER CATEGORY.

select 
    Category,
    (
        select SUM(Profit) 
        from Order_Details 
        where Category = od.Category
    ) as Total_Profit
from 
    Order_Details od
group by 
    Category;

# INSIGHT:- It helps in product development, pricing strategies, marketing efforts, nad inventory management.


# QUESTION:- TOTAL QUANTITY SOLD PER CATEGORY.

select 
    Category,
    (
        select SUM(Quantity) 
        from Order_Details 
        where Category = od.Category
    ) as Total_Quantity_Sold
from
    Order_Details od
group by 
    Category;

# INSIGHT:- To understand which categories are experencing the highest sales volume and where potential opportunities for growth or optimization may lie.

# QUESTION:-  TOTAL SALES AMOUNT PER MONTH.

select
    Order_Year,
    Order_Month,
    (
        select SUM(Target) 
        from Sales_Target 
        where Order_Year = st.Order_Year and Order_Month = st.Order_Month
    ) as Total_Sales_Amount
from
    Sales_Target st
group by 
    Order_Year,
    Order_Month;

# INSIGHT:- It assess the impact of external factors such as economic conditions or industry trends, and make data-driven decisions to maximize sales and profit.


# QUESTION:- TOTAL SALES AMOUNT FOR EACH CATEGORY AND SUB-CATEGORY.

select
    Category,
    `Sub-Category`,
    (
        select SUM(Amount) 
        from Order_Details 
        where Category = od.Category and `Sub-Category` = od.`Sub-Category`
    ) as Total_Sales_Amount
from 
    Order_Details od
group by 
    Category,
    `Sub-Category`;

# INSIGHT:- It enables them to identify which  category and sub-categories are the most lucrative and where adjustments may be needed to improve profitability.

#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------#

# QUESTION:- RANKING CUSTOMERS ORDER ID  BY THEIR TOTAL SALES AMOUNT.

select 
    `Order ID`,
    SUM(Amount) as Total_Sales_Amount,
    rank() over (order by SUM(Amount) desc) as Sales_Rank
from 
    Order_Details
group by 
    `Order ID`;

# INSIGHT:- It enables organizations to priorties customer relationship management efforts, or incentives to retain and reward valuable customers.


# QUESTION:- CALCULATING THE CUMULATIVE PROFIT OVER TIME.

select  
    `Order ID`,
    SUM(Profit) over (order by `Order ID`) as Cumulative_Profit
from 
    Order_Details;

# INSIGHT:- The organizations can identify peroid of growth assess the impact of various initiatives or market conditions and forecast future profitability.


# QUESTION:- CALCULATING THE MOVING AVERAGE OF SALES AMOUNT PER MONTH.

select 
    Order_Month,
    avg(Target) over (order by Order_month rows between  2 preceding and current row) as Moving_Average_Sales
from 
    Sales_Target;

# INSIGHT:- It provides a smoothed representation of sales trend over time .


# QUESTION:- RANKING CATEGORIES BY THEIR TOTAL SALES AMOUNT.

select
    Category,
    SUM(Target) as Total_Sales_Amount,
    rank() over (order by SUM(Target) desc) as Sales_Rank
from
    Sales_Target
group by 
    Category;

# INSIGHT:- It allows businesses to priorties resources , marketing efforts, and inventory management strategies accordingly.


# QUESTION:- CALCULATING THE PERCENTAGE CONTRIBUTION OF EACH CATEGORY TO TOTAL SALES AMOUNT.

select 
    Category,
    SUM(Target) as Total_Sales_Amount,
    SUM(Target) / SUM(SUM(Target)) over () * 100 as Sales_Contribution
from 
    Sales_Target
group by
    Category;

# INSIGHT:- It helps in understanding the relative importance of each category in driving overall sales performance.

select 
    t1.`Order ID`,
    t1.CustomerName,
    t1.State,
    t1.City,
    t1.Order_Date,
    t1.Order_Month,
    t1.Order_Year,
    t2.Amount  -- Adding column from the second table
from
    Order_List t1
join
    Order_Details t2 on t1.`Order ID` = t2.`Order ID`;

alter table Order_List
add column Amount int;

update  Order_List
join Order_Details t2 on Order_List.`Order ID` = t2.`Order ID`
set Order_List.Amount = t2.Amount;

select * from Order_List;

# YEAR OVER YEAR CHANGE SALES

select
    Order_Year,
    Total_Sales_Amount,
    lag(Total_Sales_Amount) over (order by Order_Year) as Previous_Year_Sales_Amount,
    Total_Sales_Amount - lag(Total_Sales_Amount) over (order by Order_Year) as Year_Over_Year_Change
from
    (select 
        Order_Year,
        SUM(Amount) as Total_Sales_Amount
    from
        Order_List
    group by 
        Order_Year) as Yearly_Sales;
        
# It extracts the change in sales year over year.

SELECT
    Order_Month,
    Total_Sales_Amount,
    LAG(Total_Sales_Amount) OVER (ORDER BY Order_Month) AS Previous_Month_Sales_Amount,
    Total_Sales_Amount - LAG(Total_Sales_Amount) OVER (ORDER BY Order_Month) AS Month_Over_Month_Change,
    ((Total_Sales_Amount - LAG(Total_Sales_Amount) OVER (ORDER BY Order_Month)) / LAG(Total_Sales_Amount) OVER (ORDER BY Order_Month)) * 100 AS Month_Over_Month_Change_Percentage
FROM
    (SELECT 
        Order_Month,
        SUM(Amount) AS Total_Sales_Amount
    FROM
        Order_List
    GROUP BY 
        Order_Month) AS Monthly_Sales;
        
# INSIGHT:- It extracts cahnge in sales month over month.

#------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------------------------------------------------------------------------------------#

select 
    SUM(Amount) as Total_Sales_Amount
from 
    Order_Details;
    
    
    
select 
    avg(Profit / Amount) * 100 as Average_Profit_Margin_Percentage
from
    Order_Details;
    
    

select
    SUM(Quantity) as Total_Quantity_Sold
from 
    Order_Details;
    
    
select 
    COUNT(DISTINCT `Order ID`) as Number_of_Orders
from 
    Order_List;
    
    
select
    avg(Amount) as Average_Order_Value
from
    Order_List;
    
    
select 
    COUNT(distinct CustomerName) as Total_Customers,
    COUNT(distinct CustomerName) / COUNT(distinct `Order ID`) as Customer_Acquisition_Rate
from
    Order_List;


select 
    (COUNT(distinct CustomerName) - COUNT(distinct CustomerName, Order_Year, Order_Month)) / COUNT(distinct CustomerName) as Customer_Retention_Rate
from 
    Order_List;





