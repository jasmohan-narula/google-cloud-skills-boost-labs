# Importing Data to a Firestore Database

https://www.cloudskillsboost.google/course_templates/649/labs/489700

GSP642


## Task 1. Set up Firestore in Google Cloud

1. In the Cloud Console, go to the Navigation menu and select Firestore.

2. Click +Create Database.

3. Select the Native mode option and click Continue.

4. In the Region dropdown, select **us-west1** region and then click Create Database.


## Task 2. Write database import code
```
git clone https://github.com/rosera/pet-theory
cd pet-theory/lab01
npm install @google-cloud/firestore

npm install @google-cloud/logging
```

Update the file **pet-theory/lab01/importTestData.js**


## Task 3. Create test data
```
npm install faker@5.5.3
```

Update the file **createTestData.js**

Run the following command in Cloud Shell to create the file customers_1000.csv, which will contain 1000 records of test data:
```
node createTestData 1000
```

You should receive a similar output:
```
    Created file customers_1000.csv containing 1000 records.
```


## Task 4. Import the test customer data
```
npm install csv-parse

node importTestData customers_1000.csv
```


You should receive a similar output:
```
    Writing record 500
    Writing record 1000
    Wrote 1000 records
```

## Task 5. Inspect the data in Firestore
Return to your Cloud Console tab. In the Navigation menu click on Firestore. Once there, click on the pencil icon.

Type in **/customers** and press Enter.

