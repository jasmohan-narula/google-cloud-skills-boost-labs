# Integrate BigQuery Data and Google Workspace using Apps Script: Challenge Lab

ARC133

https://www.cloudskillsboost.google/course_templates/737/labs/461599

## Task 1. Query BigQuery and log the results to Google Sheets

Navigate to script.google.com and then rename the project to "BigQuery Sheets Challenge"


## Task 2. Perform calculations on charts with Connected Sheets
### Connect a BigQuery dataset to Google Sheets

Select your Project ID **qwiklabs-gcp-00-38a02e12f630** > Public datasets > chicago_taxi_trips > taxi_trips.

Find out how many taxi companies there are in Chicago.
```
=COUNTUNIQUE(taxi_trips!company)
```

Find the percentage of taxi rides in Chicago that included a tip.
```
=COUNTIF(taxi_trips!tips,">0")
```

Find the total number of trips where the fare was greater than 0.
```
=COUNTIF(taxi_trips!fare,">0")
```


## Task 3. Use Google Charts with Connected Sheets

As a pie chart, what forms of payments are people using for their taxi rides?

As a line chart, how has revenue from mobile payments for taxi trips changed over time?

As a line chart, how have mobile payments changed over time since revenue peaked in 2015?