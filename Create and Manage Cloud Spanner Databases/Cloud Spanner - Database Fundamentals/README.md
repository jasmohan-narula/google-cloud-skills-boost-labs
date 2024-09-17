# Cloud Spanner - Database Fundamentals

https://www.cloudskillsboost.google/course_templates/643/labs/471746

GSP1048


nano spanner.tf

terraform init

terraform apply


## Extra commands
gcloud spanner databases execute-sql banking-db --instance=banking-instance  --sql="SELECT COUNT(*) FROM Customer;"