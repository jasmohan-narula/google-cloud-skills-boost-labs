Connect an App to a Cloud SQL for PostgreSQL Instance


gcloud sql connect postgres-gmemegen --user=postgres --quiet
Allowlisting your IP for incoming connection for 5 minutes...done.                                                                                                                              
Connecting to database with SQL user [postgres].Password: 
psql (16.4 (Ubuntu 16.4-1.pgdg22.04+1), server 13.15)
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, compression: off)
Type "help" for help.

postgres=> \c gmemegen_db
Password: 
psql (16.4 (Ubuntu 16.4-1.pgdg22.04+1), server 13.15)
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, compression: off)
You are now connected to database "gmemegen_db" as user "postgres".
gmemegen_db=> select * from meme;
 id |     template      |      top_text       |    bot_text     
----+-------------------+---------------------+-----------------
  1 | bill-lumbergh.jpg | Paisa nahi mil raha | Aagh lagah deh?
(1 row)

gmemegen_db=> 





history
    1  gcloud config set compute/zone "us-east4-c"
    2  export ZONE=$(gcloud config get compute/zone)
    3  gcloud config set compute/region "us-east4"
    4  export REGION=$(gcloud config get compute/region)
    5  gcloud config set compute/zone "us-east4-c"
    6  export ZONE=$(gcloud config get compute/zone)
    7  gcloud config set compute/region "us-east4"
    8  export REGION=$(gcloud config get compute/region)
    9  gcloud services enable artifactregistry.googleapis.com
   10  export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
   11  export CLOUDSQL_SERVICE_ACCOUNT=cloudsql-service-account
   12  gcloud iam service-accounts create $CLOUDSQL_SERVICE_ACCOUNT --project=$PROJECT_ID
   13  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$CLOUDSQL_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/cloudsql.admin" 
   14  export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
   15  export CLOUDSQL_SERVICE_ACCOUNT=cloudsql-service-account
   16  gcloud iam service-accounts create $CLOUDSQL_SERVICE_ACCOUNT --project=$PROJECT_ID
   17  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$CLOUDSQL_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/cloudsql.admin" 
   18  gcloud iam service-accounts keys create $CLOUDSQL_SERVICE_ACCOUNT.json     --iam-account=$CLOUDSQL_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com     --project=$PROJECT_ID
   19  clear
   20  ZONE=us-east4-c
   21  gcloud container clusters create postgres-cluster --zone=$ZONE --num-nodes=2
   22  kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=$CLOUDSQL_SERVICE_ACCOUNT.json
   23  kubectl create secret generic cloudsql-db-credentials --from-literal=username=postgres --from-literal=password=supersecret! --from-literal=dbname=gmemegen_db
   24  history



 history
    1  gcloud config set compute/zone "us-east4-c"
    2  export ZONE=$(gcloud config get compute/zone)
    3  gcloud config set compute/region "us-east4"
    4  export REGION=$(gcloud config get compute/region)
    5  gcloud config set compute/zone "us-east4-c"
    6  export ZONE=$(gcloud config get compute/zone)
    7  gcloud config set compute/region "us-east4"
    8  export REGION=$(gcloud config get compute/region)
    9  gcloud services enable artifactregistry.googleapis.com
   10  export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
   11  export CLOUDSQL_SERVICE_ACCOUNT=cloudsql-service-account
   12  gcloud iam service-accounts create $CLOUDSQL_SERVICE_ACCOUNT --project=$PROJECT_ID
   13  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$CLOUDSQL_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/cloudsql.admin" 
   14  export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
   15  export CLOUDSQL_SERVICE_ACCOUNT=cloudsql-service-account
   16  gcloud iam service-accounts create $CLOUDSQL_SERVICE_ACCOUNT --project=$PROJECT_ID
   17  gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$CLOUDSQL_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" --role="roles/cloudsql.admin" 
   18  gcloud iam service-accounts keys create $CLOUDSQL_SERVICE_ACCOUNT.json     --iam-account=$CLOUDSQL_SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com     --project=$PROJECT_ID
   19  clear
   20  gcloud config set compute/zone "us-east4-c"
   21  export ZONE=$(gcloud config get compute/zone)
   22  gcloud config set compute/region "us-east4"
   23  export REGION=$(gcloud config get compute/region)
   24  export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
   25  export CLOUDSQL_SERVICE_ACCOUNT=cloudsql-service-account
   26  kubectl create secret generic cloudsql-instance-credentials --from-file=credentials.json=$CLOUDSQL_SERVICE_ACCOUNT.json
   27  kubectl create secret generic cloudsql-db-credentials --from-literal=username=postgres --from-literal=password=supersecret! --from-literal=dbname=gmemegen_db
   28  gsutil -m cp -r gs://spls/gsp919/gmemegen .
   29  cd gmemegen
   30  export REGION=us-east4
   31  export PROJECT_ID=$(gcloud config list --format 'value(core.project)')
   32  export REPO=gmemegen
   33  gcloud auth configure-docker ${REGION}-docker.pkg.dev
   34  gcloud artifacts repositories create $REPO     --repository-format=docker --location=$REGION
   35  docker build -t ${REGION}-docker.pkg.dev/${PROJECT_ID}/gmemegen/gmemegen-app:v1 .
   36  docker push ${REGION}-docker.pkg.dev/${PROJECT_ID}/gmemegen/gmemegen-app:v1
   37  kubectl create -f gmemegen_deployment.yaml
   38  kubectl get pods
   39  kubectl expose deployment gmemegen     --type "LoadBalancer"     --port 80 --target-port 8080
   40  kubectl describe service gmemegen
   41  export LOAD_BALANCER_IP=$(kubectl get svc gmemegen \
-o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n default)
   42  echo gMemegen Load Balancer Ingress IP: http://$LOAD_BALANCER_IP
   43  POD_NAME=$(kubectl get pods --output=json | jq -r ".items[0].metadata.name")
   44  kubectl logs $POD_NAME gmemegen | grep "INFO"
   45  gcloud sql connect postgres-gmemegen --user=postgres --quiet
   46  history