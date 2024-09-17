# Create and Manage Cloud Spanner Instances: Challenge Lab

GSP381

https://www.cloudskillsboost.google/course_templates/643/labs/471750


## Task 1. Create a Cloud Spanner instance
```
export REGION=us-central1
export SPANNER_INSTANCE_NAME=banking-ops-instance
export DATABASE_NAME=banking-ops-db

gcloud spanner instances create $SPANNER_INSTANCE_NAME \
--config=regional-$REGION  \
--description="Banking Operations" \
--nodes=1
```

## Task 2. Create a Cloud Spanner database
```
gcloud spanner databases create $DATABASE_NAME \
--instance=$SPANNER_INSTANCE_NAME
```


## Task 3. Create tables in your database
```
CREATE TABLE Portfolio (
  PortfolioId INT64 NOT NULL,
  Name STRING(MAX),
  ShortName STRING(MAX),
  PortfolioInfo STRING(MAX)
) PRIMARY KEY (PortfolioId);


CREATE TABLE Category (
    CategoryId INT64 NOT NULL,
    PortfolioId INT64 NOT NULL,
    CategoryName STRING(MAX),
    PortfolioInfo STRING(MAX))
    PRIMARY KEY (CategoryId);

CREATE TABLE Product (
    ProductId INT64 NOT NULL,
    CategoryId INT64 NOT NULL,
    PortfolioId INT64 NOT NULL,
    ProductName STRING(MAX),
    ProductAssetCode STRING(25),
    ProductClass STRING(25))
    PRIMARY KEY (ProductId);

CREATE TABLE Customer (
    CustomerId STRING(36) NOT NULL,
    Name STRING(MAX) NOT NULL,
    Location STRING(MAX) NOT NULL)
    PRIMARY KEY (CustomerId);
```



## Task 4. Load simple datasets into tables
```
INSERT INTO Portfolio (PortfolioId, Name, ShortName, PortfolioInfo)
VALUES 
  (1, "Banking", "Bnkg", "All Banking Business"),
  (2, "Asset Growth", "AsstGrwth", "All Asset Focused Products"),
  (3, "Insurance", "Insurance", "All Insurance Focused Products");

INSERT INTO Category (CategoryId, PortfolioId, CategoryName)
VALUES 
  (1, 1, "Cash"),
  (2, 2, "Investments - Short Return"),
  (3, 2, "Annuities"),
  (4, 3, "Life Insurance");

INSERT INTO Product (ProductId, CategoryId, PortfolioId, ProductName, ProductAssetCode, ProductClass)
VALUES 
  (1, 1, 1, "Checking Account", "ChkAcct", "Banking LOB"),
  (2, 2, 2, "Mutual Fund Consumer Goods", "MFundCG", "Investment LOB"),
  (3, 3, 2, "Annuity Early Retirement", "AnnuFixed", "Investment LOB"),
  (4, 4, 3, "Term Life Insurance", "TermLife", "Insurance LOB"),
  (5, 1, 1, "Savings Account", "SavAcct", "Banking LOB"),
  (6, 1, 1, "Personal Loan", "PersLn", "Banking LOB"),
  (7, 1, 1, "Auto Loan", "AutLn", "Banking LOB"),
  (8, 4, 3, "Permanent Life Insurance", "PermLife", "Insurance LOB"),
  (9, 2, 2, "US Savings Bonds", "USSavBond", "Investment LOB");
```


## Task 5. Load a complex dataset
```
wget https://storage.googleapis.com/cloud-training/OCBL375/Customer_List_500.csv

python3 batch_insert.py
```

After rows are inserted
```
select count(*) from Customer;
```
- 500


## Task 6. Add a new column to an existing table
```
ALTER TABLE Category ADD COLUMN MarketingBudget INT64;
```