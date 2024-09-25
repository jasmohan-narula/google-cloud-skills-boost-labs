# Derive Insights from BigQuery Data: Challenge Lab

GSP787

https://www.cloudskillsboost.google/games/5496/labs/35507


The dataset and table that will be used for this analysis will be : bigquery-public-data.covid19_open_data.covid19_open_data


## Configurable
```
PROJECT_ID=qwiklabs-gcp-02-8373e09689f3

DATE=April 15, 2020
```


## Task 1. Total confirmed cases

Build a query that answers the question:
**"What was the total count of confirmed cases on April 15, 2020?"**

The query should return a single row containing the sum of confirmed cases across all countries. The name of the column should be `total_cases_worldwide`.

**Columns to reference:**
- `cumulative_confirmed`
- `date`


```
SELECT 
    SUM(cumulative_confirmed) AS total_cases_worldwide
FROM 
    `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE 
    date = '2020-04-15';
```

Output
```
| total_cases_worldwide     |
|---------------------------|
| 5273480                   |
```


## Task 2: Worst Affected Areas

Build a query that answers the question:
**"How many states in the US had more than 100 deaths on April 15, 2020?"**

The query should list the output in the field `count_of_states`.  
*Note: Don't include NULL values.*

**Columns to reference:**
- `country_name`
- `subregion1_name` (for state information)
- `cumulative_deceased`


```
WITH
  deaths_by_states AS (
  SELECT
    subregion1_name AS state,
    SUM(cumulative_deceased) AS death_count
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="United States of America"
    AND date='2020-04-15'
    AND subregion1_name IS NOT NULL
  GROUP BY
    subregion1_name )
SELECT
  COUNT(*) AS count_of_states
FROM
  deaths_by_states
WHERE
  death_count > 100
```

Output
```
| count_of_states           |
|---------------------------|
| 36                        |
```


## Task 3: Identify Hotspots

Build a query that answers the question:
**"List all the states in the United States of America that had more than 1500 confirmed cases on April 15, 2020?"**

The query should return the State Name and the corresponding confirmed cases arranged in descending order. The names of the fields to return are `state` and `total_confirmed_cases`.

**Columns to reference:**
- `country_code`
- `subregion1_name` (for state information)
- `cumulative_confirmed`


```
SELECT
  subregion1_name AS state,
  SUM(cumulative_confirmed) AS total_confirmed_cases
FROM
  `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
  country_code="US"
  AND date='2020-04-15'
  AND subregion1_name IS NOT NULL
GROUP BY
  subregion1_name
HAVING
  total_confirmed_cases > 1500
ORDER BY
  total_confirmed_cases DESC;
```

Output
```
| state                     | total_confirmed_cases |
|---------------------------|-----------------------|
| New York                  | 579638                |
| New Jersey                | 140871                |
| Michigan                  | 62313                 |
| Massachusetts             | 59264                 |
| Pennsylvania              | 53294                 |
| California                | 52962                 |
| Illinois                  | 49152                 |
| Louisiana                 | 43846                 |
| Florida                   | 43253                 |
| Georgia                   | 34396                 |
| Texas                     | 31598                 |
| Connecticut               | 28973                 |
| Washington                | 21803                 |
| Maryland                  | 20114                 |
| Indiana                   | 20026                 |
| Colorado                  | 16449                 |
| Ohio                      | 15582                 |
| Virginia                  | 13002                 |
| Tennessee                 | 11943                 |
| North Carolina            | 10246                 |
| Missouri                  | 9419                  |
| Alabama                   | 8354                  |
| Wisconsin                 | 8174                  |
| Arizona                   | 7924                  |
| South Carolina            | 7312                  |
| Mississippi               | 6720                  |
| Nevada                    | 6423                  |
| Rhode Island              | 6398                  |
| Utah                      | 5091                  |
| District of Columbia      | 4547                  |
| Oklahoma                  | 4526                  |
| Kentucky                  | 4505                  |
| Delaware                  | 4133                  |
| Minnesota                 | 4129                  |
| Iowa                      | 3990                  |
| Oregon                    | 3296                  |
| Idaho                     | 3125                  |
| Arkansas                  | 3118                  |
| Kansas                    | 2997                  |
| New Mexico                | 2968                  |
| South Dakota              | 2336                  |
| New Hampshire             | 2278                  |
| Nebraska                  | 1895                  |
| Maine                     | 1538                  |
| Vermont                   | 1517                  |
```


## Task 4: Fatality Ratio

Build a query that answers the question:
**"What was the case-fatality ratio in Italy for the month of April 2020?"**

The case-fatality ratio is defined as:  
**(total deaths / total confirmed cases) * 100**

The query should return the ratio for the month of April 2020 and contain the following fields in the output: `total_confirmed_cases`, `total_deaths`, `case_fatality_ratio`.

**Columns to reference:**
- `country_name`
- `cumulative_confirmed`
- `cumulative_deceased`


```
SELECT
  SUM(cumulative_deceased) AS total_deaths,
  SUM(cumulative_confirmed) AS total_confirmed_cases,
  (SUM(cumulative_deceased)/SUM(cumulative_confirmed))*100 AS case_fatality_ratio
FROM
  `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
  country_name="Italy"
  AND date BETWEEN '2020-04-01'AND '2020-04-30'
```

Output
```
| total_deaths              | total_confirmed_cases | case_fatality_ratio       |
|---------------------------|-----------------------|---------------------------|
| 1288342                   | 14452840              | 8.91410961444256          |
```


## Task 5: Identifying Specific Day

Build a query that answers the question:
**"On what day did the total number of deaths cross 8000 in Italy?"**

The query should return the date in the format `yyyy-mm-dd`.

**Columns to reference:**
- `country_name`
- `cumulative_deceased`


```
SELECT
  date
FROM
  `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
  country_name="Italy"
  AND cumulative_deceased > 8000
LIMIT
  1
```

Output
```
| date                      |
|---------------------------|
| 2022-08-19                |
```


## Task 6: Finding Days with Zero Net New Cases

The following query is written to identify the number of days in India between February 22, 2020, and March 15, 2020, when there were zero increases in the number of confirmed cases. However, it is not executing properly.

**Query:**

```
WITH
  india_cases_by_date AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name = "India"
    AND date BETWEEN '2020-02-22'
    AND '2020-03-15'
  GROUP BY
    date
  ORDER BY
    date ASC ),
  india_previous_day_comparison AS (
  SELECT
    date,
    cases,
    LAG(cases) OVER(ORDER BY date) AS previous_day,
    cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases
  FROM
    india_cases_by_date )
SELECT
  COUNT(*)
FROM
  india_previous_day_comparison
WHERE
  net_new_cases = 0;
```


Output
```
| f0_                       |
|---------------------------|
| 6                         |
```


## Task 7: Doubling Rate

Using the previous query as a template, write a query to find out the dates on which the confirmed cases increased by more than 20% compared to the previous day (indicating a doubling rate of ~7 days) in the US between March 22, 2020, and April 20, 2020.

The query needs to return the following:
- List of dates
- Confirmed cases on that day
- Confirmed cases the previous day
- Percentage increase in cases between the days

Use the following names for the returned fields:
- `Date`
- `Confirmed_Cases_On_Day`
- `Confirmed_Cases_Previous_Day`
- `Percentage_Increase_In_Cases`


```
WITH
  us_cases_by_date AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="United States of America"
    AND date BETWEEN '2020-03-22'
    AND '2020-04-20'
  GROUP BY
    date
  ORDER BY
    date ASC ),
  us_previous_day_comparison AS (
  SELECT
    date,
    cases,
    LAG(cases) OVER(ORDER BY date) AS previous_day,
    cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases,
    (cases - LAG(cases) OVER(ORDER BY date))*100/LAG(cases) OVER(ORDER BY date) AS percentage_increase
  FROM
    us_cases_by_date )
SELECT
  Date,
  cases AS Confirmed_Cases_On_Day,
  previous_day AS Confirmed_Cases_Previous_Day,
  percentage_increase AS Percentage_Increase_In_Cases
FROM
  us_previous_day_comparison
WHERE
  percentage_increase > 20;
```


Output
```
| Date         | Confirmed_Cases_On_Day | Confirmed_Cases_Previous_Day | Percentage_Increase_In_Cases |
|--------------|-------------------------|-------------------------------|-------------------------------|
| 2020-03-23   | 178113                  | 144693                        | 23.097178163421866            |
| 2020-03-26   | 312220                  | 257259                        | 21.364072782682044            |
| 2020-03-24   | 214851                  | 178113                        | 20.626231661922489            |
```


## Task 8: Recovery Rate

Build a query to list the recovery rates of countries arranged in descending order (limit to 20) up to the date May 10, 2020.

Restrict the query to only those countries having more than 50K confirmed cases.

The query needs to return the following fields:
- `country`
- `recovered_cases`
- `confirmed_cases`
- `recovery_rate`


```
WITH
  cases_by_country AS (
  SELECT
    country_name AS country,
    SUM(cumulative_confirmed) AS cases,
    SUM(cumulative_recovered) AS recovered_cases
  FROM
    bigquery-public-data.covid19_open_data.covid19_open_data
  WHERE
    date = '2020-05-10'
  GROUP BY
    country_name ),
  recovered_rate AS (
  SELECT
    country,
    cases,
    recovered_cases,
    (recovered_cases * 100)/cases AS recovery_rate
  FROM
    cases_by_country )
SELECT
  country,
  cases AS confirmed_cases,
  recovered_cases,
  recovery_rate
FROM
  recovered_rate
WHERE
  cases > 50000
ORDER BY
  recovery_rate DESC
LIMIT
  20
```

Output
```
| country                   | confirmed_cases         | recovered_cases           | recovery_rate             |
|---------------------------|-------------------------|---------------------------|---------------------------|
| France                    | 216220                  | 4566869                   | 2112.1399500508742        |
| China                     | 156251                  | 146635                    | 93.845799386883925        |
| Germany                   | 424353                  | 240082                    | 56.57601100970183         |
| Italy                     | 643471                  | 210372                    | 32.69331485024189         |
| Philippines               | 51314                   | 16305                     | 31.774954203531202        |
| Chile                     | 57731                   | 13112                     | 22.712234328177235        |
| India                     | 195804                  | 38556                     | 19.691119691119692        |
| Brazil                    | 574241                  | 64957                     | 11.311801142725789        |
| Russia                    | 429699                  | 34037                     | 7.9211261836774112        |
| Switzerland               | 60664                   | 3866                      | 6.3728075959382826        |
| Portugal                  | 55162                   | 2549                      | 4.6209347014248943        |
| United States of America   | 4021510                | 131601                    | 3.2724275210057914        |
| Spain                     | 640922                  | 5139                      | 0.80181363722886712       |
| Mexico                    | 52740                   |                           |                           |
| United Kingdom            | 823585                  |                           |                           |
| Canada                    | 139773                  |                           |                           |
| Belgium                   | 105974                  |                           |                           |
| Iran                      | 109286                  |                           |                           |
| Pakistan                  | 899102                  |                           |                           |
| Sweden                    | 53706                   |                           |                           |	
```


## Task 9: CDGR - Cumulative Daily Growth Rate

The following query is trying to calculate the CDGR (Cumulative Daily Growth Rate) on April 15, 2020, for France since the day the first case was reported. The first case was reported on January 24, 2020.

The CDGR is calculated as:

**CDGR = ((last_day_cases / first_day_cases) ^ (1 / days_diff)) - 1**

Where:
- **last_day_cases** is the number of confirmed cases on May 10, 2020
- **first_day_cases** is the number of confirmed cases on January 24, 2020
- **days_diff** is the number of days between January 24 and May 10, 2020

The query isn’t executing properly. Can you fix the error to make the query execute successfully?


```
WITH
  france_cases AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS total_cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="France"
    AND date IN ('2020-01-24',
      '2020-04-15')
  GROUP BY
    date
  ORDER BY
    date),
  summary AS (
  SELECT
    total_cases AS first_day_cases,
    LEAD(total_cases) OVER(ORDER BY date) AS last_day_cases,
    DATE_DIFF(LEAD(date) OVER(ORDER BY date),date, day) AS days_diff
  FROM
    france_cases
  LIMIT
    1 )
SELECT
  first_day_cases,
  last_day_cases,
  days_diff,
  POW((last_day_cases/first_day_cases),(1/days_diff))-1 AS cdgr
FROM
  summary
```


Output
```
| first_day_cases          | last_day_cases           | days_diff                | cdgr                      |
|---------------------------|--------------------------|--------------------------|---------------------------|
| 3                         | 167984                   | 82                       | 0.14262633037515982       |
```



## Task 10: Create a Looker Studio Report

Create a Looker Studio report that plots the following for the United States:

- Number of Confirmed Cases
- Number of Deaths

**Date range:** 2020-03-27 to 2020-04-27


---
Run this query in BigQuery for verification:--
```
SELECT
  date,
  SUM(cumulative_confirmed) AS country_cases,
  SUM(cumulative_deceased) AS country_deaths
FROM
  bigquery-public-data.covid19_open_data.covid19_open_data
WHERE
  date BETWEEN '2020-03-27'
  AND '2020-04-27'
  AND country_name ="United States of America"
GROUP BY
  date
```

1. Open https://lookerstudio.google.com
2. Click "Create"
3. Select "Datasource". Select "BigQuery. "This page will open https://lookerstudio.google.com/datasources/create/
4. Click authorize and 
5. Select "Custom Query"
    - Select Billing Project
    - Then paste the above query and click "CONNECT"
6. Then build the report.
    - Date as Dimensions
    - Others as Measures


<img src="1 - Explore with Looker Studio.png" width="500"/>

<img src="2 - Auto generated report.png" width="500"/>

<img src="3 - Looker Studio - Connect.png" width="500"/>

<img src="4 - Looker Studio - Line Chart.png" width="500"/>