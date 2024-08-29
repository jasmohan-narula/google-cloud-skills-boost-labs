# Running a MongoDB Database in Kubernetes with StatefulSets

https://www.cloudskillsboost.google/games/5383/labs/34950

GSP022

# Task 1. Set a compute zone
```
gcloud config set compute/zone us-east4-c
```


# Task 2. Create a new cluster
```
gcloud container clusters create hello-world --num-nodes=2
```


# Task 3. Setting up

Run the following command to clone the MongoDB/Kubernetes replica set from the Github repository:
```
gsutil -m cp -r gs://spls/gsp022/mongo-k8s-sidecar .
```

Once it's cloned, navigate to the *StatefulSet* directory with the following command:
```
cd ./mongo-k8s-sidecar/example/StatefulSet/
```

## Create the StorageClass
This configuration creates a new StorageClass called "fast" that is backed by SSD volumes.

Run the following command to deploy the StorageClass:
```
kubectl apply -f googlecloud_ssd.yaml
```


# Task 4. Deploying the Headless Service and StatefulSet

Since the two are packaged in mongo-statefulset.yaml, we can run the following command to run both of them:
```
kubectl apply -f mongo-statefulset.yaml
```


# Task 5. Connect to the MongoDB Replica set


Wait for the MongoDB replica set to be fully deployed

Run the following command to view and confirm that all three members are up:
```
kubectl get statefulset
```

## Initiating and Viewing the MongoDB replica set

Run this command to view:
```
kubectl get pods
```

Connect to the first replica set member:
```
kubectl exec -ti mongo-0 -- mongosh
```

Let's instantiate the replica set with a default configuration by running the rs.initiate() command:
```
rs.initiate()
```

Print the replica set configuration; run the rs.conf() command:
```
rs.conf()
```

Type "exit" and press enter to quit the REPL.



# Task 6. Scaling the MongoDB replica set


To scale up the number of replica set members from 3 to 5, run this command:
```
kubectl scale --replicas=5 statefulset mongo
```

Run this command to view them:
```
kubectl get pods
```

To scale down the number of replica set members from 5 back to 3, run this command:
```
kubectl scale --replicas=3 statefulset mongo
```


# Task 7. Using the MongoDB replica set

Using a database is outside the scope of this lab, however for this case, the connection string URI would be:
```
mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo:27017/dbname_?
```


# Task 8. Clean up


To clean up the deployed resources, run the following commands to delete the StatefulSet, Headless Service, and the provisioned volumes.

Delete the StatefulSet:
```
kubectl delete statefulset mongo
```

Delete the service:
```
kubectl delete svc mongo
```

Delete the volumes:
```
kubectl delete pvc -l role=mongo
```

Finally, you can delete the test cluster:
```
gcloud container clusters delete "hello-world"
```

Press Y then Enter to continue deleting the test cluster.