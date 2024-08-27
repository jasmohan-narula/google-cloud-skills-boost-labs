Google Kubernetes Engine: Qwik Start

https://www.cloudskillsboost.google/games/5381/labs/34916

GSP100


# Set default Region and Zone
```
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-c
```

# Create a GKE cluster
```
gcloud container clusters create --machine-type=e2-medium --zone=us-central1-c lab-cluster
```

# Task 3. Get authentication credentials for the cluster
```
gcloud container clusters get-credentials lab-cluster
```

# Task 4. Deploy an application to the cluster
Create a new Deployment: hello-server
```
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
```

Expose Port
```
kubectl expose deployment hello-server --type=LoadBalancer --port 8080
```

Inspect
```
kubectl get service
```

View the application on
http://[EXTERNAL-IP]:8080


# Task 5. Deleting the cluster
```
gcloud container clusters delete lab-cluster
```