Perform Predictive Data Analysis in BigQuery: Challenge Lab

https://www.cloudskillsboost.google/games/5414/labs/35103

GSP374

https://www.cloudskillsboost.google/focuses/37320?parent=catalog


# Challenge scenario
Use BigQuery to load the data from the Cloud Storage bucket, write and execute queries in BigQuery, analyze soccer event data. Then use BigQuery ML to train an expected goals model on the soccer event data and evaluate the impressiveness of World Cup goals.


## Task 1. Data ingestion

Project id - *qwiklabs-gcp-03-a18bc21a6a30*

Dataset Id - *soccer*


- Source	Cloud Storage
- Select file from Cloud Storage bucket	spls/bq-soccer-analytics/events.json
- File format	JSONL (Newline delimited JSON)
- Table name	*events676*
- Schema	Check the box marked Schema *Auto detect*

__


- Source	Cloud Storage
- Select file from Cloud Storage bucket	spls/bq-soccer-analytics/tags2name.csv
- File format	CSV
- Table name	*tags3name*
- Schema	Check the box marked Schema *Auto detect*



## Task 2. Analyze soccer data
```
SELECT
playerId,
(Players.firstName || ' ' || Players.lastName) AS playerName,
COUNT(id) AS numPKAtt,
SUM(IF(101 IN UNNEST(tags.id), 1, 0)) AS numPKGoals,
SAFE_DIVIDE(
SUM(IF(101 IN UNNEST(tags.id), 1, 0)),
COUNT(id)
) AS PKSuccessRate
FROM
`soccer.events676` Events
LEFT JOIN
`soccer.players` Players ON
Events.playerId = Players.wyId
WHERE
eventName = 'Free Kick' AND
subEventName = 'Penalty'
GROUP BY
playerId, playerName
HAVING
numPkAtt >= 5
ORDER BY
PKSuccessRate DESC, numPKAtt DESC
```


## Task 3. Gain insight by analyzing soccer data
```
WITH
Shots AS
(
SELECT
*,
/* 101 is known Tag for 'goals' from goals table */
(101 IN UNNEST(tags.id)) AS isGoal,
SQRT(
POW((100 - positions[ORDINAL(1)].x) * 90/60, 2) +
POW((60 - positions[ORDINAL(1)].y) * 107/81, 2)) AS shotDistance
FROM
`soccer.events676`
WHERE
eventName = 'Shot' OR
(eventName = 'Free Kick' AND subEventName IN ('Free kick shot', 'Penalty'))
)
SELECT
ROUND(shotDistance, 0) AS ShotDistRound0,
COUNT(*) AS numShots,
SUM(IF(isGoal, 1, 0)) AS numGoals,
AVG(IF(isGoal, 1, 0)) AS goalPct
FROM
Shots
WHERE
shotDistance <= 50
GROUP BY
ShotDistRound0
ORDER BY
ShotDistRound0
```


## Task 4. Create a regression model using soccer data

Calculate shot distance from (x,y) coordinates

- Define a function *soccer.GetShotDistanceToGoal676* for calculating the shot distance from (x,y) coordinates in the soccer dataset using the following code-blocks:

- Function 1 *soccer.GetShotDistanceToGoal676*
```
CREATE FUNCTION `soccer.GetShotDistanceToGoal676`(x INT64, y INT64)
RETURNS FLOAT64
AS (
 /* Translate 0-100 (x,y) coordinate-based distances to absolute positions
 using "average" field dimensions of 107x81 before combining in 2D dist calc */
 SQRT(
   POW((90 - x) * 107/100, 2) +
   POW((60 - y) * 81/100, 2)
   )
 );
```

Calculate shot angle from (x,y) coordinates

- Define a function *soccer.GetShotAngleToGoal676* for calculating the shot angle from (x,y) coordinates in the soccer dataset using the following code-blocks:

- Function 2 *soccer.GetShotAngleToGoal676*
```
CREATE FUNCTION `soccer.GetShotAngleToGoal676`(x INT64, y INT64)
RETURNS FLOAT64
AS (
 SAFE.ACOS(
   /* Have to translate 0-100 (x,y) coordinates to absolute positions using
   "average" field dimensions of 107x81 before using in various distance calcs */
   SAFE_DIVIDE(
     ( /* Squared distance between shot and 1 post, in meters */
       (POW(107 - (x * 107/100), 2) + POW(40.5 + (7.32/2) - (y * 81/100), 2)) +
       /* Squared distance between shot and other post, in meters */
       (POW(107 - (x * 107/100), 2) + POW(40.5 - (7.32/2) - (y * 81/100), 2)) -
       /* Squared length of goal opening, in meters */
       POW(7.32, 2)
     ),
     (2 *
       /* Distance between shot and 1 post, in meters */
       SQRT(POW(107 - (x * 107/100), 2) + POW(40.5 + 7.32/2 - (y * 81/100), 2)) *
       /* Distance between shot and other post, in meters */
       SQRT(POW(107 - (x * 107/100), 2) + POW(40.5 - 7.32/2 - (y * 81/100), 2))
     )
    )
  /* Translate radians to degrees */
  ) * 180 / ACOS(-1)
 )
;
```


Create an expected goals model using BigQuery ML

- Use BigQuery ML to create and execute a machine learning model *soccer.xg_logistic_reg_model_676* in BigQuery using standard SQL queries.

- Model *soccer.xg_logistic_reg_model_676*
```
CREATE OR REPLACE MODEL `soccer.xg_logistic_reg_model_676`
OPTIONS(
model_type = 'LOGISTIC_REG',
input_label_cols = ['isGoal']
) AS
SELECT
Events.subEventName AS shotType,
/* 101 is known Tag for 'goals' from goals table */
(101 IN UNNEST(Events.tags.id)) AS isGoal,
`soccer.GetShotDistanceToGoal676`(Events.positions[ORDINAL(1)].x,
Events.positions[ORDINAL(1)].y) AS shotDistance,
`soccer.GetShotAngleToGoal676`(Events.positions[ORDINAL(1)].x,
Events.positions[ORDINAL(1)].y) AS shotAngle
FROM
`soccer.events676` Events
LEFT JOIN
`soccer.matches` Matches ON
Events.matchId = Matches.wyId
LEFT JOIN
`soccer.competitions` Competitions ON
Matches.competitionId = Competitions.wyId
WHERE
/* Filter out World Cup matches for model fitting purposes */
Competitions.name != 'World Cup' AND
/* Includes both "open play" & free kick shots (including penalties) */
(
eventName = 'Shot' OR
(eventName = 'Free Kick' AND subEventName IN ('Free kick shot', 'Penalty'))
) AND
`soccer.GetShotAngleToGoal676`(Events.positions[ORDINAL(1)].x,
Events.positions[ORDINAL(1)].y) IS NOT NULL
;
```



## Task 5. Make predictions from new data with the BigQuery model

Now that you've fit an expected goals model of reasonable accuracy and explainability, you can apply it to "new" data - in this case, the 2018 World Cup (which was left out of the model fitting).


The logistic regression model *soccer.xg_logistic_reg_model_676* created in the previous step is used to assess the difficulty of each shot and goal in that competition, enabling the identification of the most "impressive" goals in the tournament.

Get probabilities for all shots in the 2018 World Cup

```
SELECT
predicted_isGoal_probs[ORDINAL(1)].prob AS predictedGoalProb,
* EXCEPT (predicted_isGoal, predicted_isGoal_probs),
FROM
ML.PREDICT(
MODEL `soccer.xg_logistic_reg_model_676`, 
(
 SELECT
   Events.playerId,
   (Players.firstName || ' ' || Players.lastName) AS playerName,
   Teams.name AS teamName,
   CAST(Matches.dateutc AS DATE) AS matchDate,
   Matches.label AS match,
 /* Convert match period and event seconds to minute of match */
   CAST((CASE
     WHEN Events.matchPeriod = '1H' THEN 0
     WHEN Events.matchPeriod = '2H' THEN 45
     WHEN Events.matchPeriod = 'E1' THEN 90
     WHEN Events.matchPeriod = 'E2' THEN 105
     ELSE 120
     END) +
     CEILING(Events.eventSec / 60) AS INT64)
     AS matchMinute,
   Events.subEventName AS shotType,
   /* 101 is known Tag for 'goals' from goals table */
   (101 IN UNNEST(Events.tags.id)) AS isGoal,
 
   `soccer.GetShotDistanceToGoal676`(Events.positions[ORDINAL(1)].x,
       Events.positions[ORDINAL(1)].y) AS shotDistance,
   `soccer.GetShotAngleToGoal676`(Events.positions[ORDINAL(1)].x,
       Events.positions[ORDINAL(1)].y) AS shotAngle
 FROM
   `soccer.events676` Events
 LEFT JOIN
   `soccer.matches` Matches ON
       Events.matchId = Matches.wyId
 LEFT JOIN
   `soccer.competitions` Competitions ON
       Matches.competitionId = Competitions.wyId
 LEFT JOIN
   `soccer.players` Players ON
       Events.playerId = Players.wyId
 LEFT JOIN
   `soccer.teams` Teams ON
       Events.teamId = Teams.wyId
 WHERE
   /* Look only at World Cup matches to apply model */
   Competitions.name = 'World Cup' AND
   /* Includes both "open play" & free kick shots (but not penalties) */
   (
     eventName = 'Shot' OR
     (eventName = 'Free Kick' AND subEventName IN ('Free kick shot'))
   ) AND
   /* Filter only to goals scored */
   (101 IN UNNEST(Events.tags.id))
)
)
ORDER BY
predictedgoalProb
```