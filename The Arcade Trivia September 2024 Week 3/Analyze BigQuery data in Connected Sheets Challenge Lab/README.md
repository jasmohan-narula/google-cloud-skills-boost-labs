# Analyze BigQuery data in Connected Sheets: Challenge Lab

ARC103

https://www.cloudskillsboost.google/games/5440/labs/35264

This lab is very similar to https://www.cloudskillsboost.google/course_templates/632/labs/464082


## Task 1. Open Google Sheets and connect to a BigQuery dataset
Log in to Sheets using the credentials provided, and connect to qwiklabs-gcp-02-0249e75db574 > Public datasets > new_york_taxi_trips > tlc_yellow_trips_2022.

- Open a new Blank Google Sheet.
- Navigate to Data > Data connectors > Connect to BigQuery.
- Click 'Get Connected'
- In the BigQuery connection dialog, select your project ID (qwiklabs-gcp-02-0249e75db574).
- - Browse to Public datasets > new_york_taxi_trips > tlc_yellow_trips_2022.
Select the dataset, and click "Connect."


## Task 2. Use a formula to count rows that meet a specific criteria
Use a formula to count the number of taxi trips that include an airport fee.

```
=COUNTIF(tlc_yellow_trips_2022!airport_fee, ">0")
```


## Task 3. Create charts to visualize BigQuery data
Create a pie chart to identify which payment type is most frequently used to pay the fare amount.
| Payment Type Code | Payment Type Description |
|-------------------|--------------------------|
| 1                 | Credit Card              |
| 2                 | Cash                     |
| 3                 | No charge                |
| 4                 | Dispute                  |
| 5                 | Unknown                  |
| 6                 | Voided trip              |


## Task 4. Extract data from BigQuery to Connected Sheets
Extract 10,000 rows of data from the columns pickup_datetime, dropoff_datetime, trip_distance, and fare_amount, ordered by longest trip first.


## Task 5. Calculate new columns to transform existing column data
Calculate a new column that displays the percentage of each fare amount that was used to pay toll fees (based on the toll_amount column).

Column name - toll_percentage
```
=IF(fare_amount>0, tolls_amount/fare_amount*100, 0)
```