# Build a Data Warehouse with BigQuery: Challenge Lab

https://www.cloudskillsboost.google/course_templates/624/labs/489694

GSP340


## Task 1
### Create a table partitioned by date
The starting point for the machine learning model will be the oxford_policy_tracker table in the COVID 19 Government Response public dataset which contains details of different actions taken by governments to curb the spread of Covid-19 in their jurisdictions.

Given the fact that there will be models based on a range of time periods, you have to create a dataset and then create a date partitioned version of the oxford_policy_tracker table in your newly created dataset, with an expiry time set to 1445 days.

While creating a table, you have also been instructed to exclude the United Kingdom ( alpha_3_code=GBR), Brazil ( alpha_3_code=BRA), Canada ( alpha_3_code=CAN) & the United States of America (alpha_3_code=USA) as these will be subject to more in-depth analysis through nation and state specific analysis.

Create a new dataset covid and create a table oxford_policy_tracker in that dataset partitioned by date, with an expiry of 1445 days. The table should initially use the schema defined for the oxford_policy_tracker table in the COVID 19 Government Response public dataset .
You must also populate the table with the data from the source table for all countries and exclude the United Kingdom (GBR), Brazil (BRA), Canada (CAN) and the United States (USA) as instructed above.


https://console.cloud.google.com/bigquery?p=bigquery-public-data&d=covid19_govt_response&page=dataset

```
select * from `bigquery-public-data.covid19_govt_response.oxford_policy_tracker` limit 100
```

```
CREATE OR REPLACE TABLE `qwiklabs-gcp-02-50a064ac5982.covid.oxford_policy_tracker`
PARTITION BY date
OPTIONS(
  partition_expiration_days = 1445
) AS
SELECT * FROM `bigquery-public-data.covid19_govt_response.oxford_policy_tracker`
WHERE alpha_3_code NOT IN ('GBR', 'BRA', 'CAN', 'USA');
```




## Task 2
Populate the mobility record data
In this task, you need to add the mobility record data, which requires to extract average values for the six component fields that comprise the mobility record data from the mobility_report table from the Google COVID 19 Mobility public dataset .

Your coworker has also given you a SQL snippet that is currently being used to analyze trends in the Google Mobility data daily mobility patterns. You might need to use this as part of the query that will add the daily country data for the mobility record in table provided in the task description.

(Query for reference)
```
SELECT country_region, date,
AVG(retail_and_recreation_percent_change_from_baseline) as avg_retail,
AVG(grocery_and_pharmacy_percent_change_from_baseline) as avg_grocery,
AVG(parks_percent_change_from_baseline) as avg_parks,
AVG(transit_stations_percent_change_from_baseline) as avg_transit,
AVG( workplaces_percent_change_from_baseline ) as avg_workplace,
AVG( residential_percent_change_from_baseline) as avg_residential
FROM `bigquery-public-data.covid19_google_mobility.mobility_report`
GROUP BY country_region, date
```


Verify the pre-created BigQuery dataset 'covid_data' within this dataset, populate the mobility record in 'consolidate_covid_tracker_data' table with data from the Google COVID 19 Mobility public dataset .

Note: In case you're unable to view pre-created resources in bigquery as per the task description,"your Google Cloud resources are still being provisioned, please refresh the page and try again in a few minutes." If you do, just wait a short time and reload your page.

https://console.cloud.google.com/bigquery?p=bigquery-public-data&d=covid19_google_mobility&page=dataset



```
UPDATE `qwiklabs-gcp-02-50a064ac5982.covid_data.consolidate_covid_tracker_data` as t0
SET
    t0.mobility.avg_retail      = t1.avg_retail,
   t0.mobility.avg_grocery     = t1.avg_grocery,
   t0.mobility.avg_parks       = t1.avg_parks,
   t0.mobility.avg_transit     = t1.avg_transit,
   t0.mobility.avg_workplace   = t1.avg_workplace,
   t0.mobility.avg_residential = t1.avg_residential

FROM
   ( SELECT country_region, date,
      AVG(retail_and_recreation_percent_change_from_baseline) as avg_retail,
      AVG(grocery_and_pharmacy_percent_change_from_baseline)  as avg_grocery,
      AVG(parks_percent_change_from_baseline) as avg_parks,
      AVG(transit_stations_percent_change_from_baseline) as avg_transit,
      AVG(workplaces_percent_change_from_baseline) as avg_workplace,
      AVG(residential_percent_change_from_baseline)  as avg_residential
      FROM `bigquery-public-data.covid19_google_mobility.mobility_report`
      GROUP BY country_region, date
   ) AS t1
WHERE
   CONCAT(t0.country_name, t0.date) = CONCAT(t1.country_region, t1.date)
```


```
select * from qwiklabs-gcp-02-50a064ac5982.covid_data.consolidate_covid_tracker_data;
```


## Task 3

Query missing data in population & country_area columns
In this task, you need to find out the countries which do not have population data and countries that do not have country area information.

Within the BigQuery dataset named 'covid_data' contains one table named oxford_policy_tracker_worldwide, run a query to find the missing countries in the population and country_area data from 'oxford_policy_tracker_worldwide' table. The query should list countries that do not have any population data and countries that do not have country area information, ordered by country name. If a country has neither population or country area it must appear twice.

Note: In case you're unable to view pre-created resources in bigquery as per the task description,"your Google Cloud resources are still being provisioned, please refresh the page and try again in a few minutes." If you do, just wait a short time and reload your page.



```
select DISTINCT(country_name) FROM `qwiklabs-gcp-02-50a064ac5982.covid_data.oxford_policy_tracker_worldwide`
    WHERE population IS NULL
UNION ALL
    select DISTINCT(country_name) FROM `qwiklabs-gcp-02-50a064ac5982.covid_data.oxford_policy_tracker_worldwide`
    WHERE country_area is NULL
    ORDER BY country_name ASC;
```



## Task 4
Create a new table for country population data
In this step, you need to create a copy of covid_19_geographic_distribution_worldwide table from European Center for Disease Control COVID 19 public dataset into your dataset provided in the task description.

Create a new table 'pop_data_2019' within the dataset named as 'covid_data'. The table should initially use the schema defined for the 'covid_19_geographic_distribution_worldwide' table data from the European Center for Disease Control COVID 19 public dataset.

Add the country population data to the 'pop_data_2019' table with covid_19_geographic_distribution_worldwide table data from the European Center for Disease Control COVID 19 public dataset.

Note: In case you're unable to view pre-created resources in bigquery as per the task description,"your Google Cloud resources are still being provisioned, please refresh the page and try again in a few minutes." If you do, just wait a short time and reload your page.


https://console.cloud.google.com/bigquery?p=bigquery-public-data&d=covid19_ecdc&page=dataset


```
CREATE OR REPLACE TABLE `qwiklabs-gcp-02-50a064ac5982.covid_data.pop_data_2019` AS
SELECT
  country_territory_code,
  pop_data_2019
FROM 
  `bigquery-public-data.covid19_ecdc.covid_19_geographic_distribution_worldwide`
GROUP BY
  country_territory_code,
  pop_data_2019
ORDER BY
  country_territory_code
```



## Tips and tricks
Tip 1. Remember that if you are instructed to create table you must exclude the United Kingdom (GBR), Brazil (BRA), Canada (CAN) and the United States (USA) data.

Tip 2. If you are updating the schema for a BigQuery table you can use the console to add the columns and record elements or you can use the command line bqutility to update the schema by providing a JSON file with all of field definitions as explained in the BigQuery Standard SQL reference documentation.

Tip 3. The covid19_ecdc table in the European Center for Disease Control COVID 19 public dataset contains a population column that you can use if you are populating the populationcolumn based on your task description.

Tip 4. The country_names_area table from the Census Bureau International public dataset does not contain a three letter country code column, but you can join it to table provided in task description using the full text country_name column that exists in both tables.

Tip 5. If you are updating the mobility record remember that you must select (and average) a number of records for each country and date combination so that you get a single average of each child column in the mobility record. You must join the resulting data to your working table using the same combination of country name and date that you used to group the source mobility records to ensure there is a unique mapping between the averaged source mobility table results and the records in your table that have a single entry for each country and date combination.

Tip 6. The UNION option followed by the ALL keyword combines the results of two queries where each query lists distinct results without combining duplicate results that arise from the union into a single row.