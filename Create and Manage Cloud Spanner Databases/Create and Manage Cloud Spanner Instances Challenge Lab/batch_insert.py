from google.cloud import spanner
from google.cloud.spanner_v1 import param_types
import csv

INSTANCE_ID = "banking-ops-instance"
DATABASE_ID = "banking-ops-db"

spanner_client = spanner.Client()
instance = spanner_client.instance(INSTANCE_ID)
database = instance.database(DATABASE_ID)

CSV_FILE_PATH = "Customer_List_500.csv"



def load_data_from_csv(CSV_FILE_PATH):
    # Open the CSV file and read the data
    with open(CSV_FILE_PATH, mode='r') as file:
        reader = csv.reader(file)
        rows = [row for row in reader]
        
    return rows

def insert_data_into_spanner(rows):
    # Insert data into the Customer table
    with database.batch() as batch:
        batch.insert(
            table="Customer",
            columns=("CustomerId", "Name", "Location"),
            values=[(row[0], row[1], row[2]) for row in rows]
        )
    print("Rows inserted")

# Load data from the CSV file
data_rows = load_data_from_csv(CSV_FILE_PATH)

# Insert data into Spanner
insert_data_into_spanner(data_rows)
