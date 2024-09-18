# AlloyDB - Database Fundamentals

GSP1083

https://www.cloudskillsboost.google/course_templates/642/labs/501230

https://www.cloudskillsboost.google/games/5427/labs/35185


## Set Region and PROJECT ID
```
REGION=us-east4
gcloud config set compute/region $REGION

ZONE=us-east4-a
gcloud config set compute/zone us-central1-c

PROJECT_ID=$(gcloud config get-value project)
```

## Task 1. Create a cluster and instance
```
export CLUSTER_ID=lab-cluster
export ALLOYDB_PASSWORD=Change3Me
export NETWORK_NAME=peering-network
```

```
gcloud beta alloydb clusters create $CLUSTER_ID \
    --password=$ALLOYDB_PASSWORD \
    --network=$NETWORK_NAME \
    --region=$REGION \
    --project=$PROJECT_ID
```


Note: Select 2 vCPU, 16 GB as your machine type.
```
export INSTANCE_ID=lab-instance

gcloud beta alloydb instances create $INSTANCE_ID \
    --instance-type=PRIMARY \
    --cpu-count=2 \
    --region=$REGION  \
    --cluster=$CLUSTER_ID  \
    --project=$PROJECT_ID
```

After AlloyDB cluster and instance are created. On the Cloud Console Navigation menu , under Databases click AlloyDB for PostgreSQL then Clusters.

You're now on the Overview page for the new cluster you created. The bottom section contains details on your instance. Please make note of the Private IP address in the instances section. Copy the Private IP address to a text file so that you can paste the value in a later step.

https://console.cloud.google.com/alloydb/clusters?referrer=search&cloudshell=true
```
10.120.0.2
```


## Task 2. Create tables and insert data in your database

On the Navigation menu (Navigation menu icon), under Compute Engine click VM instances.
For the instance named alloydb-client, in the Connect column, click SSH to open a terminal window.

Or run the command:-
```
export PRIVATE_IP_ADDRESS_ALLOYDB_CLIENT_VM=$(gcloud compute instances describe alloydb-client \
--format='get(networkInterfaces[0].networkIP)' \
--zone=$ZONE)
echo $PRIVATE_IP_ADDRESS_ALLOYDB_CLIENT_VM
```

```
gcloud compute ssh alloydb-client --zone=$ZONE
```
```
Do you want to continue (Y/n)?  y
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
```

Once inside the VM terminal,
### Set Region and PROJECT ID
```
REGION=us-east4
gcloud config set compute/region $REGION

ZONE=us-east4-a
gcloud config set compute/zone us-central1-c

PROJECT_ID=$(gcloud config get-value project)
```

Replace the following command  with the  correct IP address of your AlloyDB instance
- export ALLOYDB=<PRIVATE_IP_ADDRESS_ALLOYDB_CLIENT_VM>
```
export ALLOYDB=10.120.0.2
```

```
echo $ALLOYDB  > alloydbip.txt 

psql -h $ALLOYDB -U postgres
```
Enter the password
- Change3Me


Run the queries, one at a time:-
```
CREATE TABLE regions (
    region_id bigint NOT NULL,
    region_name varchar(25)
) ;

ALTER TABLE regions ADD PRIMARY KEY (region_id);
```

```
INSERT INTO regions VALUES ( 1, 'Europe' );

INSERT INTO regions VALUES ( 2, 'Americas' );

INSERT INTO regions VALUES ( 3, 'Asia' );

INSERT INTO regions VALUES ( 4, 'Middle East and Africa' );
```

```
SELECT region_id, region_name from regions;
```
Type \q to exit the psql client.


```
gsutil cp gs://cloud-training/OCBL403/hrm_load.sql hrm_load.sql

psql -h $ALLOYDB -U postgres
```
Enter the password
- Change3Me

```
\i hrm_load.sql

\dt
```

```
select job_title, max_salary 
from jobs 
order by max_salary desc;
```
Type \q to exit the psql client.

Type exit to close the terminal window.


##
## Task 3. Use the Google Cloud CLI with AlloyDB

### Create a cluster and instance with CLI
```
gcloud beta alloydb clusters create gcloud-lab-cluster \
    --password=$ALLOYDB_PASSWORD \
    --network=$NETWORK_NAME \
    --region=$REGION \
    --project=$PROJECT_ID

gcloud beta alloydb instances create gcloud-lab-instance \
    --instance-type=PRIMARY \
    --cpu-count=2 \
    --region=$REGION  \
    --cluster=gcloud-lab-cluster \
    --project=$PROJECT_ID

gcloud beta alloydb clusters list
```


## Task 4. Deleting a cluster
```
gcloud beta alloydb clusters delete gcloud-lab-cluster \
    --force \
    --region=$REGION  \
    --project=$PROJECT_ID
```