# Analyzing Billing Data with BigQuery

GSP621

https://www.cloudskillsboost.google/games/5427/labs/35192

## Task 1. Locate your dataset and table in BigQuery

Dataset - billing_dataset

Table - enterprise_billing



## Task 2. Examine the billing data

Which of the following lists some of the information provided by this table?
check
- The account charges are billed to; the service provided; usage cost; and the invoice on which this charge appears


The first 200 entries show that the Cloud Pub/Sub service was provided to the same billing account and within the same country.
- False



## Task 3. Analyze data using SQL queries

### Query 1: Analyze your data based on costs
This script queries data in the enterprise_billing table for records with a Cost of greater than zero.
```
SELECT * FROM `billing_dataset.enterprise_billing` WHERE Cost > 0

SELECT
 project.name as Project_Name,
 service.description as Service,
 location.country as Country,
 cost as Cost
FROM `billing_dataset.enterprise_billing`;
```

To see when the service was used, what field would you add to the query? (You can test in BigQuery)
close
- usage_start_time



### Query 2: Examine key information
For this example, the number of unique services that are available is the key information you want. Run a query that combines the service description and the SKU description and then lists that as line items.

```
SELECT CONCAT(service.description, ' : ',sku.description) as Line_Item FROM `billing_dataset.enterprise_billing` GROUP BY 1
```

What did you just do?
- Determined and listed how many unique services were used in this billing cycle


How many different line items does the sample Cloud Billing data cover?
- 68 services



### Query 3: Analyze service usage
In this step you look at service usage to find out the number of times a resource used a service/SKU.

```
SELECT CONCAT(service.description, ' : ',sku.description) as Line_Item, Count(*) as NUM FROM `billing_dataset.enterprise_billing` GROUP BY CONCAT(service.description, ' : ',sku.description)
```

How many services were used six times in the billing record?
- 0


What services produced 3349 logs in your billing record?
- Cloud Functions : Network Egress from us-central1


### Query 4: Determine which project has the most records
This query counts how many times a project.id appears in a record and groups the results by project.id.

```
SELECT project.id, count(*) as count from `billing_dataset.enterprise_billing` GROUP BY project.id
```

Which Google Cloud Project has the most billing records?
- ctg-dev-241406


### Query 5. Find the cost per project
In this step you find the cost breakdown for each project:

```
SELECT ROUND(SUM(cost),2) as Cost, project.name from `billing_dataset.enterprise_billing` GROUP BY project.name
```

Which project generates the largest cost?
- CTG - Dev