# Implement Cloud Security Fundamentals on Google Cloud: Challenge Lab
GSP342

https://www.cloudskillsboost.google/course_templates/645/labs/489299

https://www.cloudskillsboost.google/games/5426/labs/35168


## Challenge scenario
As per the organization's security standards you must ensure that the new Kubernetes Engine cluster is built according to the organization's most recent security standards and thereby must comply with the following:

The cluster must be deployed using a dedicated service account configured with the least privileges required.

The cluster must be deployed as a Kubernetes Engine private cluster, with the public endpoint disabled, and the master authorized network set to include only the ip-address of the Orca group's management jumphost.

The Kubernetes Engine private cluster must be deployed to the **orca-build-subnet** in the **Orca Build VPC**.
From a previous project you know that the minimum permissions required by the service account that is specified for a Kubernetes Engine cluster is covered by these three built in roles:
- roles/monitoring.viewer
- roles/monitoring.metricWriter
- roles/logging.logWriter

You must bind the above roles to the service account used by the cluster as well as a custom role that you must create in order to provide access to any other services specified by the development team. Initially you have been told that the development team requires that the service account used by the cluster should have the permissions necessary to add and update objects in Google Cloud Storage buckets. To do this you will have to create a new custom IAM role that will provide the following permissions:
- storage.buckets.get
- storage.objects.get
- storage.objects.list
- storage.objects.update
- storage.objects.create

All new cloud objects and services that you create should include the **"orca-"** prefix.

For all tasks in this lab, use the **us-east4** region and the **us-east4-b** zone.


## Setup / Configurable
```
export PROJECT_ID=qwiklabs-gcp-03-52f1df1a5c21
export CUSTOM_SECURIY_ROLE=orca_storage_editor_941
export SERVICE_ACCOUNT=orca-private-cluster-178-sa
export CLUSTER_NAME=orca-cluster-445
export ZONE=us-east4-b

gcloud config set compute/zone $ZONE
```



## Task 1. Create a custom security role
Your first task is to create a new custom IAM security role named **orca_storage_editor_941** that provides the necessary permissions for Google Cloud Storage buckets and objects. This role will grant the service account the ability to create and update storage objects.

```
touch role-definition.yaml

gcloud iam roles create $CUSTOM_SECURIY_ROLE --project $DEVSHELL_PROJECT_ID --file role-definition.yaml
```


## Task 2. Create a service account
Your second task is to create the dedicated service account that will be used as the service account for your new private cluster. You must name this account **orca-private-cluster-178-sa**.

```
gcloud iam service-accounts create $SERVICE_ACCOUNT --display-name "Orca Private Cluster SA"
```


## Task 3. Bind a custom security role to a service account
You must now bind the Cloud Operations logging and monitoring roles that are required for Kubernetes Engine Cluster service accounts as well as the custom IAM role you created for storage permissions to the Service Account you created earlier.

```
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role projects/$DEVSHELL_PROJECT_ID/roles/$CUSTOM_SECURIY_ROLE

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role roles/monitoring.viewer

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role roles/monitoring.metricWriter

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role roles/logging.logWriter
```



## Task 4. Create and configure a new Kubernetes Engine private cluster

You must now use the service account you have configured when creating a new Kubernetes Engine private cluster. The new cluster configuration must include the following:

- The cluster must be called **orca-cluster-445**
- The cluster must be deployed to the subnet **orca-build-subnet**
- The cluster must be configured to use the **orca-private-cluster-178-sa** service account.
- The private cluster options **enable-master-authorized-networks, enable-ip-alias, enable-private-nodes,** and **enable-private-endpoint** must be enabled.

Once the cluster is configured you must add the internal ip-address of the **orca-jumphost** compute instance to the master authorized network list.


```
gcloud compute instances list --filter="name:orca-jumphost" --format="get(networkInterfaces[0].networkIP)"
```
- 192.168.10.2

```
gcloud container clusters create $CLUSTER_NAME \
    --network orca-build-vpc \
    --subnetwork orca-build-subnet \
    --enable-ip-alias \
    --enable-private-nodes \
    --enable-private-endpoint \
    --enable-master-authorized-networks \
    --master-authorized-networks 192.168.10.2/32 \
    --service-account $SERVICE_ACCOUNT@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
    --zone $ZONE
```



## Task 5. Deploy an application to a private Kubernetes Engine cluster
You have a simple test application that can be deployed to any cluster to quickly test that basic container deployment functionality is working and that basic services can be created and accessed. You must configure the environment so that you can deploy this simple demo to the new cluster using the jumphost **orca-jumphost**.

SSH into 'orca-jumphost'
```
gcloud compute ssh --zone "$ZONE" "orca-jumphost" --project "$DEVSHELL_PROJECT_ID"
```
Run the export commands from the top again inside the VM SSH session.

Then run the following commands:--
```
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> ~/.bashrc
source ~/.bashrc

gcloud container clusters get-credentials $CLUSTER_NAME --internal-ip

kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment hello-server --name orca-hello-service --type LoadBalancer --port 80 --target-port 8080

EXTERNAL_IP=$(kubectl get service orca-hello-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo $EXTERNAL_IP
```

When you open the ip address in browser, you should get an output like this:
```
Hello, world!
Version: 1.0.0
Hostname: hello-server-7d95ddcc98-t44r5
```