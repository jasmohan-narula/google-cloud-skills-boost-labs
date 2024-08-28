Cloud SQL with Terraform

https://www.cloudskillsboost.google/games/5416/labs/35113

GSP234

In this hands-on lab you will learn how to create Cloud SQL instances with Terraform, then set up the Cloud SQL Proxy, testing the connection with a MySQL client.


# Task 1. Download necessary files
```
mkdir sql-with-terraform
cd sql-with-terraform
gsutil cp -r gs://spls/gsp234/gsp234.zip .
unzip gsp234.zip
```

# Task 2. Understand the code
Click on Open Editor in Cloud Shell.
Open variables.tf and modify the project and region variables to the values shown below:
- project: qwiklabs-gcp-02-b4aa6e2ec9de
- region: us-east4

# Task 3. Run Terraform
```
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```
This will take a little while to complete.


# Task 5. Installing the Cloud SQL Proxy

Download proxy client
```
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
chmod +x cloud_sql_proxy
```

# Task 6. Test connection to the database
```
export GOOGLE_PROJECT=$(gcloud config get-value project)
MYSQL_DB_NAME=$(terraform output -json | jq -r '.instance_name.value')
MYSQL_CONN_NAME="${GOOGLE_PROJECT}:us-east4:${MYSQL_DB_NAME}"
```

Start connection with command:
```
./cloud_sql_proxy -instances=${MYSQL_CONN_NAME}=tcp:3306
```

## Second tab for connecting
Now you'll start another Cloud Shell tab by clicking on plus (+) icon. You'll use this shell to connect to the Cloud SQL proxy.
```
cd ~/sql-with-terraform
```

Get the generated password for MYSQL:
```
echo MYSQL_PASSWORD=$(terraform output -json | jq -r '.generated_user_password.value')
```

Test the MySQL connection:
```
mysql -udefault -p --host 127.0.0.1 default
```

When prompted, enter the value of MYSQL_PASSWORD, found in the output above, and press Enter.

You should successfully log into the MYSQL command line. Exit from MYSQL by typing Ctrl + D.

If you go back to the first Cloud Shell tab you'll see logs for the connections made to the Cloud SQL Proxy.


# Quiz - Task 7. Test your understanding
Which command is used to create a Terraform execution plan?
- terraform plan

The Cloud SQL Proxy provides secure access to your Cloud SQL instances without having to allowlist IP addresses or configure SSL.
- True