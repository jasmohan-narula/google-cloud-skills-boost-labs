# Deploy Kubernetes Applications on Google Cloud: Challenge Lab

GSP318

https://www.cloudskillsboost.google/course_templates/663/labs/464654


## Configuration
```
PROJECT_ID=$(gcloud config get-value project)
export REPO_NAME=valkyrie-repo
export DOCKER_IMAGE_NAME=valkyrie-app
export DOCKER_IMAGE_VERSION=0.0.1

REGION=us-central1
gcloud config set compute/region $REGION

ZONE=us-central1-b
gcloud config set compute/zone $ZONE
```


## Task 1. Create a Docker image and store the Dockerfile
```
source <(gsutil cat gs://cloud-training/gsp318/marking/setup_marking_v2.sh)

cd ~/marking
gcloud source repos clone valkyrie-app

touch valkyrie-app/Dockerfile
vi valkyrie-app/Dockerfile

docker build -t $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION valkyrie-app/.

bash ~/marking/step1_v2.sh
```

## Task 2. Test the created Docker image
```
docker run -p 8080:8080 --name $DOCKER_IMAGE_NAME -d $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION

docker ps
curl http://localhost:8080

bash ~/marking/step2_v2.sh
```


## Task 3. Push the Docker image to the Artifact Registry
```
gcloud artifacts repositories create $REPO_NAME --repository-format=docker --location=$REGION

gcloud auth configure-docker $REGION-docker.pkg.dev

docker build -t $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION valkyrie-app/.
```

```
docker images
>   REPOSITORY                                                                           TAG       IMAGE ID       CREATED          SIZE
    valkyrie-app                                                                         v0.0.1    84f5cb86fc76   14 minutes ago   769MB
    us-central1-docker.pkg.dev/qwiklabs-gcp-01-44799cebd33a/valkyrie-repo/valkyrie-app   v0.0.1    84f5cb86fc76   14 minutes ago   769MB
```

```
docker push $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_VERSION
```


## Task 4. Create and expose a deployment in Kubernetes
```
export CLUSTER_NAME=valkyrie-dev

gcloud container clusters get-credentials $CLUSTER_NAME
>   Fetching cluster endpoint and auth data.
    kubeconfig entry generated for valkyrie-dev.
```

```
ls ~/marking/valkyrie-app/k8s
> deployment.yaml  service.yaml

sed -i 's|IMAGE_HERE|'"$REGION"'-docker.pkg.dev/'"$PROJECT_ID"'/'"$REPO_NAME"'/'"$DOCKER_IMAGE_NAME"':'"$DOCKER_IMAGE_VERSION"'|g' ~/marking/valkyrie-app/k8s/deployment.yaml
```

```
cd ~/marking
kubectl apply -f valkyrie-app/k8s/deployment.yaml
kubectl apply -f valkyrie-app/k8s/service.yaml
>   deployment.apps/valkyrie-dev created
    service/valkyrie-dev created
```

## Output
```
kubectl get services valkyrie-dev -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
kubectl get services
```