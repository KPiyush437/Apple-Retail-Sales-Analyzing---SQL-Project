Project Overview

This project demonstrates the use of SQL for fundamental and advanced business analysis by exploring over 1 million rows of Apple retail sales and warranty data. The dataset contains information about stores, products, sales transactions, and warranty claims across Apple retail locations worldwide.

Entity Relationship Diagram (ERD)

Database Schema

This project uses five main tables:

stores – Apple retail store information

store_id: Unique store identifier

store_name: Name of the store

city, country: Store location

category – Product category details

category_id: Unique category identifier

category_name: Name of the category

products – Apple product details

product_id, product_name

category_id references category table

launch_date, price

sales – Records of sales transactions

sale_id, sale_date

store_id, product_id references respective tables

quantity

warranty – Warranty claim data

claim_id, claim_date

sale_id references sales table

repair_status (e.g., Paid Repaired, Warranty Void)

Objectives & SQL Exercises

The project is structured into three tiers to develop SQL skills progressively:

Easy to Medium (10 Questions)

Count stores per country

Total units sold per store

Identify December 2023 sales

Stores without warranty claims

Percentage of "Warranty Void" claims

Highest-selling store last year

Unique products sold last year

Average price per product category

Warranty claims in 2020

Best-selling day for each store

Medium to Hard (5 Questions)

Least-selling product by country and year

Warranty claims within 180 days of sale

Claims for recently launched products

Months with >5,000 units sold in the USA

Product category with most warranty claims

Project Focus

Complex Joins & Aggregations: Extracting meaningful insights from multiple tables

Window Functions: Running totals, growth ratios, time-based analysis

Data Segmentation: Performance insights by time period and product lifecycle

Real-World Problem Solving: Practical business questions for analysts

Dataset Details

Size: 1M+ rows

Time Span: Multi-year data for trend analysis

Geography: Apple stores across multiple countries

Conclusion

This project allows me to develop fundamental and advanced SQL skills, handle large datasets, and produce business-relevant insights. 
