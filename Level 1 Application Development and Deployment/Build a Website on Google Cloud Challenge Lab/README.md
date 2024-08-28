Build a Website on Google Cloud: Challenge Lab

https://www.cloudskillsboost.google/games/5379/labs/34888

GSP319

# Instructions

Some FancyStore, Inc. standards you should follow:

Create your cluster in europe-west4

Naming is normally team-resource, e.g. an instance could be named fancystore-orderservice1.

Allocate cost effective resource sizes. Projects are monitored and excessive resource use will result in the containing project's termination.

Use the e2-medium machine type unless directed otherwise.

You've been told to deploy all of your resources in the europe-west4-b zone, so first you'll need to create a GKE cluster for it. Start with a 3 node cluster to begin with.

Create your cluster as follows:
- Cluster name: fancy-cluster-121
- Region: europe-west4
- Node count: 3



# Commands

## Task 1. Download the monolith code and build your container
```
nvm install --lts
```

```
git clone https://github.com/googlecodelabs/monolith-to-microservices
cd monolith-to-microservices
./setup.sh
```

```
cd monolith
npm start
```

```
cd ~/monolith-to-microservices/monolith
docker build -t fancy-monolith-898:1.0.0 .
```

```
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-monolith-898:1.0.0
```


Go to Artifact Registory
https://console.cloud.google.com/artifacts?referrer=search&cloudshell=true&project=qwiklabs-gcp-03-ee28befff715

and check for *gcr.io/qwiklabs-gcp-03-ee28befff715*


## Task 2. Create a kubernetes cluster and deploy the application


```
gcloud config set compute/zone europe-west4-b
```

```
gcloud container clusters create fancy-cluster-121 \
    --region europe-west4 \
    --num-nodes 3 \
    --disk-type=pd-standard
gcloud container clusters list
```

```
gcloud container clusters get-credentials fancy-cluster-121 --region europe-west4

kubectl create deployment fancy-monolith-898 --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-monolith-898:1.0.0
kubectl expose deployment fancy-monolith-898 --type=LoadBalancer --port=80 --target-port=8080
```

Check if deployed with command
```
kubectl get services
```
or UI
Gateways, Services & Ingress

http://35.204.168.230:80/


## Task 3. Create new microservices

```
cd ~/monolith-to-microservices/microservices/src/orders
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-orders-738:1.0.0
```

```
cd ~/monolith-to-microservices/microservices/src/products
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-products-941:1.0.0
```


## Task 4. Deploy the new microservices
```
gcloud container clusters get-credentials fancy-cluster-121 --region europe-west4

kubectl create deployment fancy-orders-738 --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-orders-738:1.0.0
kubectl expose deployment fancy-orders-738 --type=LoadBalancer --port=80 --target-port=8081

kubectl create deployment fancy-products-941 --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-products-941:1.0.0
kubectl expose deployment fancy-products-941 --type=LoadBalancer --port=80 --target-port=8082

kubectl get deployments
kubectl get services
```

### If there are issues, run the following commands and try again
```
kubectl delete service fancy-orders-738
kubectl delete service fancy-products-941
kubectl delete deployment fancy-products-941
kubectl delete deployment fancy-orders-738
```

You should get API running on the external IPs like this:-
- http://35.204.129.15/api/products
- http://34.91.120.210/api/orders


## Task 5. Configure and deploy the Frontend microservice

```
cd ~/monolith-to-microservices/react-app
nano .env
```

Update the .env file the External IPs you got in the previous step
```
REACT_APP_ORDERS_URL=http://34.91.120.210/api/orders
REACT_APP_PRODUCTS_URL=http://35.204.129.15/api/products
```

Save and build the application
```
npm run build
```


## Task 6. Create a containerized version of the Frontend microservice
```
cd ~/monolith-to-microservices/microservices/src/frontend
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-frontend-774:1.0.0 .
```

## Task 7. Deploy the Frontend microservice
```
gcloud container clusters get-credentials fancy-cluster-121 --region europe-west4
kubectl create deployment fancy-frontend-774 --image=gcr.io/${GOOGLE_CLOUD_PROJECT}/fancy-frontend-774:1.0.0
kubectl expose deployment fancy-frontend-774 --type=LoadBalancer --port=80 --target-port=8080
kubectl get services
```


Now the frontend application should be running and accessible via the External IP like this
- http://35.204.26.254/