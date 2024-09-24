# Networking 101

GSP016

https://www.cloudskillsboost.google/games/5425/labs/35156


## Set Region
```
gcloud config set compute/zone "europe-west4-c"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "europe-west4"
export REGION=$(gcloud config get compute/region)
```



## Task 2. Creating a custom network
### To create a custom network:

1. Click **Navigation menu > VPC network**.
2. Click **Create VPC Network** and name it `taw-custom-network`.
3. On the **Custom** tab, create:
   - **Subnet name**: `subnet-europe-west4`
   - **Region**: `europe-west4`
   - **IP address range**: `10.0.0.0/16`
4. Click **Done**.

### The populated Create a VPC network dialog box:

5. Now click **Add Subnet** and add 2 more subnets in their respective regions:
   - `subnet-us-west1`, `us-west1`, `10.1.0.0/16`
   - `subnet-europe-west1`, `europe-west1`, `10.2.0.0/16`
6. Click **Create** to finish.



## Task 3. Adding firewall rules


### Add firewall rules through the Console
#### Creating a Firewall Rule in the Cloud Console:

1. In the **Cloud console**, navigate to **VPC networks** and click on the `taw-custom-network`.

2. Click the **Firewalls** tab, then **Add Firewall rule**.

3. Enter the following information:

   | Field           | Value            | Comments                                             |
   |-----------------|------------------|------------------------------------------------------|
   | **Name**        | `nw101-allow-http`| New rule name                                        |
   | **Targets**     | Specified target tags | Which instances to apply the firewall rule to      |
   | **Target tags** | `http`            | The tag we created                                   |
   | **Source filter**| IPv4 ranges      | We will open the firewall for any IP address         |
   | **Source IPv4 ranges** | `0.0.0.0/0` | You will open the firewall for any IP address        |
   | **Protocols and ports** | Specified protocols and ports, then check the **tcp** box, and type `80` | Only HTTP is allowed.

4. Click **Create** and wait until the command succeeds.

Next, you'll create the additional firewall rules you'll need.


### Create Additional Firewall Rules
These additional firewall rules will allow ICMP, internal communication, SSH, and RDP. You can create them using the Console.

#### ICMP Firewall Rule

| Field                  | Value                        | Comments                                                |
|------------------------|------------------------------|---------------------------------------------------------|
| **Name**               | `nw101-allow-icmp`          | New rule name                                           |
| **Targets**            | Specified target tags        | Select from the Targets dropdown                        |
| **Target tags**        | `rules`                     | Tag                                                     |
| **Source filter**      | IPv4 ranges                 | We will open the firewall for any IP address on this list. |
| **Source IPv4 ranges** | `0.0.0.0/0`                 | We will open the firewall for any IP address from the Internet. |
| **Protocols and ports**| Specified protocols and ports, other protocols. Select and type `icmp`| The protocols and ports the firewall applies to |



### Internal Communication Firewall Rule

| Field                  | Value                                       | Comments                                                  |
|------------------------|---------------------------------------------|-----------------------------------------------------------|
| **Name**               | `nw101-allow-internal`                     | New rule name                                            |
| **Targets**            | All instances in the network                | Select from the Targets dropdown                          |
| **Source filter**      | IPv4 ranges                                | The filter used to apply the rule to specific traffic sources |
| **Source IPv4 ranges** | `10.0.0.0/16`, `10.1.0.0/16`, `10.2.0.0/16`| We will open the firewall for these IP ranges.           |
| **Protocols and ports**| Specified protocols and ports, then TCP: `0-65535`, UDP: `0-65535`, Other: `icmp` | Allows TCP: `0-65535`, UDP: `0-65535`, and ICMP.         |


### SSH Firewall Rule

| Field                  | Value                     | Comments                                                  |
|------------------------|---------------------------|-----------------------------------------------------------|
| **Name**               | `nw101-allow-ssh`        | New rule name                                            |
| **Targets**            | Specified target tags     | `ssh` - The instances to which you apply the firewall rule |
| **Source filter**      | IPv4 ranges              | The filter used to apply the rule to specific traffic sources |
| **Source IPv4 ranges** | `0.0.0.0/0`              | We will open the firewall for any IP address from the Internet. |
| **Protocols and ports**| Specified protocols and ports, check the TCP box, then type `22` | Allows TCP: `22`.                                       |


### RDP Firewall Rule

| Field                  | Value                     | Comments                                                  |
|------------------------|---------------------------|-----------------------------------------------------------|
| **Name**               | `nw101-allow-rdp`        | New rule name                                            |
| **Targets**            | All instances in the network | Select from the Targets dropdown                          |
| **Source filter**      | IPv4 ranges              | Filter IP addresses                                       |
| **Source IPv4 ranges** | `0.0.0.0/0`              | We will open the firewall for any IP address from the Internet. |
| **Protocols and ports**| Specified protocols and ports, check the TCP box, then type `3389` | Allows TCP: `3389`.                                       |




Use the Console to review the firewall rules in your network.








# Answer

Copy the three terraform files and then run the following commands in Google Cloud Console Terminal:-
```
terraform init

terraform apply
```