# Set Up a Google Cloud Network: Challenge Lab

GSP314

https://www.cloudskillsboost.google/course_templates/641/labs/507316

As part of this challenge, you will need to create the following:
- A VPC network with two subnetworks and firewalls need to be created to connect new resources together.
- Launch two VMs in each subnet and verify that these machines can successfully communicate with each other using the protocols you've configured.


## Task 1. Create networks

### Overview
Create a VPC network with two subnets and configure firewall rules to allow connections between resources.

### Steps

1. **Create a VPC Network**
   - **Name**: `vpc-network-y52q`
   - **Routing Mode**: Regional dynamic routing mode

2. **Create Subnet 1**
   - **Name**: `subnet-a-h5pn`
   - **Region**: `us-east1`
   - **IP Stack Type**: IPv4 (single-stack)
   - **IPv4 Range**: `10.10.10.0/24`

3. **Create Subnet 2**
   - **Name**: `subnet-b-jz9i`
   - **Region**: `us-east4`
   - **IP Stack Type**: IPv4 (single-stack)
   - **IPv4 Range**: `10.10.20.0/24`

### Firewall Configuration
Ensure to configure the necessary firewall rules to enable connectivity between the resources within the created VPC network and subnets.



## Task 2: Add Firewall Rules

### Overview
On this network, your team will need to connect to Linux and Windows machines using SSH and RDP, as well as diagnose network communication issues via ICMP.

### Steps

1. **Create Firewall Rule: `svbc-firewall-ssh`**
   - **Network**: `vpc-network-y52q`
   - **Priority**: 1000
   - **Traffic**: Ingress
   - **Action**: Allow
   - **Targets**: All instances in the network
   - **IPv4 Ranges**: `0.0.0.0/0`
   - **Protocol**: TCP
   - **Port**: 22

2. **Create Firewall Rule: `cwmy-firewall-rdp`**
   - **Network**: `vpc-network-y52q`
   - **Priority**: 65535
   - **Traffic**: Ingress
   - **Action**: Allow
   - **Targets**: All instances in the network
   - **IPv4 Ranges**: `0.0.0.0/24`
   - **Protocol**: TCP
   - **Port**: 3389

3. **Create Firewall Rule: `bgct-firewall-icmp`**
   - **Network**: `vpc-network-y52q`
   - **Priority**: 65535
   - **Traffic**: Ingress
   - **Action**: Allow
   - **Targets**: All instances in the network
   - **IPv4 Ranges**: `0.0.0.0/24`
   - **Protocol**: ICMP



## Task 3: Add VMs to Your Network

### Overview
Create a virtual machine in each subnet and confirm that the machines can communicate with each other using a protocol that you have already set up. Each machine will use network tags that the firewall rules need to allow network traffic.

### Steps

1. **Create Virtual Machine: `us-test-01`**
   - **Subnet**: `subnet-a-h5pn`
   - **Zone**: `us-east1-c`
   - **Network Tags**: Ensure the appropriate tags are applied for firewall rules.

2. **Create Virtual Machine: `us-test-02`**
   - **Subnet**: `subnet-b-jz9i`
   - **Zone**: `us-east4-b`
   - **Network Tags**: Ensure the appropriate tags are applied for firewall rules.


## Solution
- Copy the 3 files (main.tf, output.tf, variables.tf) into your GCP Cloud Console.
- Modify the variables.tf values to match the dynamically generated values from the project lab on Cloud Skills Boost.
- Run the following commands:-
```
terraform init
terraform apply
```

Do you want to perform these actions?

**Enter a values:** yes