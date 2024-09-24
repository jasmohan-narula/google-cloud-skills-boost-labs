# Create a Custom Network and Apply Firewall Rules
GSP159

https://www.cloudskillsboost.google/course_templates/641/labs/507314

Via **gcloud** commands

## Set your region and zone
```
gcloud config set compute/zone "us-west1-a"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "us-west1"
export REGION=$(gcloud config get compute/region)
```

## Task 1. Create custom network with Cloud Shell
```
gcloud compute networks create taw-custom-network --subnet-mode custom

gcloud compute networks subnets create subnet-us-west1 \
   --network taw-custom-network \
   --region us-west1 \
   --range 10.0.0.0/16

gcloud compute networks subnets create subnet-us-east1 \
   --network taw-custom-network \
   --region us-east1 \
   --range 10.1.0.0/16

gcloud compute networks subnets create subnet-us-east4 \
   --network taw-custom-network \
   --region us-east4 \
   --range 10.2.0.0/16

gcloud compute networks subnets list \
   --network taw-custom-network
```


## Task 2. Add firewall rules
### Add firewall rules using Cloud Shell

- http
```
gcloud compute firewall-rules create nw101-allow-http \
--allow tcp:80 --network taw-custom-network --source-ranges 0.0.0.0/0 \
--target-tags http
```

### Create additional firewall rules
- ICMP
```
gcloud compute firewall-rules create "nw101-allow-icmp" --allow icmp --network "taw-custom-network" --target-tags rules
```

- Internal Communication
```
gcloud compute firewall-rules create "nw101-allow-internal" --allow tcp:0-65535,udp:0-65535,icmp --network "taw-custom-network" --source-ranges "10.0.0.0/16","10.2.0.0/16","10.1.0.0/16"
```

- SSH
```
gcloud compute firewall-rules create "nw101-allow-ssh" --allow tcp:22 --network "taw-custom-network" --target-tags "ssh"
```

- RDP
```
gcloud compute firewall-rules create "nw101-allow-rdp" --allow tcp:3389 --network "taw-custom-network"
```