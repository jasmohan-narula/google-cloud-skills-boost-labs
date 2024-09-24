# Test Network Latency Between VMs
GSP161

https://www.cloudskillsboost.google/course_templates/641/labs/507315


## Set your region and zone
```
gcloud config set compute/zone "europe-west1-c"
export ZONE=$(gcloud config get compute/zone)

gcloud config set compute/region "europe-west1"
export REGION=$(gcloud config get compute/region)
```

## Task 1. Connect VMs and check latency
```
gcloud compute instances create us-test-01 \
--subnet subnet-europe-west1 \
--zone europe-west1-c \
--machine-type e2-standard-2 \
--tags ssh,http,rules
```
- 34.78.131.19


```
gcloud compute instances create us-test-02 \
--subnet subnet-us-central1 \
--zone us-central1-f \
--machine-type e2-standard-2 \
--tags ssh,http,rules
```
- 35.184.139.168


```
gcloud compute instances create us-test-03 \
--subnet subnet-us-east4 \
--zone us-east4-b \
--machine-type e2-standard-2 \
--tags ssh,http,rules
```
- 35.221.2.216



### Verify you can connect your VM


ping -c 3 \<us-test-02-external-ip-address\>

```
ping -c 3 34.78.131.19
```


In the SSH window of us-test-01, type the following command to use an ICMP (Internet Control Message Protocol) echo against us-test-02 and us-test-03, adding the external IP address for the VM in-line:
```
gcloud compute ssh --zone "europe-west1-c" "us-test-01" --project "qwiklabs-gcp-00-8e70831f3489"

ping -c 3 35.184.139.168
ping -c 3 35.221.2.216
```



### Use ping to measure latency

Use ping to measure the latency between these regions - run the following command after opening an SSH window on the us-test-01:
```
ping -c 3 us-test-02.us-central1-f
```

## Task 2. Traceroute and Performance testing

Install these performance tools in the SSH window for us-test-01:
```
sudo apt-get update
sudo apt-get -y install traceroute mtr tcpdump iperf whois host dnsutils siege
```

```
traceroute www.icann.org
traceroute -m 255 bad.horse
traceroute us-test-02.us-central1-f
```

## Task 3. Use iperf to test performance


SSH into us-test-02 and install the performance tools:
```
gcloud compute ssh --zone "us-central1-f" "us-test-02" --project "qwiklabs-gcp-00-8e70831f3489"

sudo apt-get update

sudo apt-get -y install traceroute mtr tcpdump iperf whois host dnsutils siege
```


SSH into us-test-01 and run:
```
iperf -s #run in server mode
```

On us-test-02 SSH run this iperf:
```
iperf -c us-test-01.europe-west1-c #run in client mode
```


- Output
```
student-04-017f8514ae81@us-test-02:~$ iperf -c us-test-01.europe-west1-c #run in client mode
------------------------------------------------------------
Client connecting to us-test-01.europe-west1-c, TCP port 5001
TCP window size: 45.0 KByte (default)
------------------------------------------------------------
[  3] local 10.1.0.2 port 48114 connected with 10.0.0.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3] 0.0000-10.0402 sec   253 MBytes   211 Mbits/sec
```



### Between VMs within a region
```
gcloud compute instances create us-test-04 \
--subnet subnet-europe-west1 \
--zone europe-west1-c \
--tags ssh,http
```


SSH to us-test-04 and install performance tools:
```
gcloud compute ssh --zone "europe-west1-c" "us-test-04" --project "qwiklabs-gcp-00-8e70831f3489"

sudo apt-get update

sudo apt-get -y install traceroute mtr tcpdump iperf whois host dnsutils siege
```


On us-test-02 SSH run:
```
iperf -s -u #iperf server side
```

On us-test-01 SSH run:
```
iperf -c us-test-02.us-central1-f -u -b 2G #iperf client side - send 2 Gbits/s
```

- Output
```
------------------------------------------------------------
Client connecting to us-test-02.us-central1-f, UDP port 5001
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  3] local 10.0.0.2 port 52846 connected with 10.1.0.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3] 0.0000-10.0000 sec  2.50 GBytes  2.15 Gbits/sec
[  3] Sent 1826115 datagrams
[  3] Server Report:
[ ID] Interval       Transfer     Bandwidth        Jitter   Lost/Total Datagrams
[  3] 0.0000-10.0091 sec  2.30 GBytes  1.97 Gbits/sec   0.007 ms 149458/1826114 (8.2%)
[  3] 0.0000-10.0091 sec  65 datagrams received out-of-order
```



In the SSH window for us-test-01 run:
```
iperf -s
```

In the SSH window for us-test-02 run:
```
iperf -c us-test-01.europe-west1-c -P 20
```


- Output
```
[ 10] local 10.1.0.2 port 43452 connected with 10.0.0.2 port 5001
------------------------------------------------------------
Client connecting to us-test-01.europe-west1-c, TCP port 5001
TCP window size: 45.0 KByte (default)
------------------------------------------------------------
[  3] local 10.1.0.2 port 43366 connected with 10.0.0.2 port 5001
[ 20] local 10.1.0.2 port 43496 connected with 10.0.0.2 port 5001
[ 14] local 10.1.0.2 port 43396 connected with 10.0.0.2 port 5001
[  4] local 10.1.0.2 port 43382 connected with 10.0.0.2 port 5001
[  7] local 10.1.0.2 port 43362 connected with 10.0.0.2 port 5001
[ 18] local 10.1.0.2 port 43468 connected with 10.0.0.2 port 5001
[ 17] local 10.1.0.2 port 43424 connected with 10.0.0.2 port 5001
[ 15] local 10.1.0.2 port 43436 connected with 10.0.0.2 port 5001
[  8] local 10.1.0.2 port 43488 connected with 10.0.0.2 port 5001
[  5] local 10.1.0.2 port 43480 connected with 10.0.0.2 port 5001
[ 21] local 10.1.0.2 port 43388 connected with 10.0.0.2 port 5001
[ 19] local 10.1.0.2 port 43444 connected with 10.0.0.2 port 5001
[ 12] local 10.1.0.2 port 43392 connected with 10.0.0.2 port 5001
[  6] local 10.1.0.2 port 43412 connected with 10.0.0.2 port 5001
[ 11] local 10.1.0.2 port 43532 connected with 10.0.0.2 port 5001
[ 16] local 10.1.0.2 port 43500 connected with 10.0.0.2 port 5001
[ 13] local 10.1.0.2 port 43526 connected with 10.0.0.2 port 5001
[ 22] local 10.1.0.2 port 43504 connected with 10.0.0.2 port 5001
[  9] local 10.1.0.2 port 43516 connected with 10.0.0.2 port 5001
[ ID] Interval       Transfer     Bandwidth
[  5] 0.0000-10.0023 sec   224 MBytes   188 Mbits/sec
[  4] 0.0000-10.0142 sec   226 MBytes   189 Mbits/sec
[  6] 0.0000-10.0039 sec   207 MBytes   173 Mbits/sec
[ 14] 0.0000-10.0127 sec   228 MBytes   191 Mbits/sec
[ 15] 0.0000-10.0172 sec   224 MBytes   188 Mbits/sec
[ 16] 0.0000-10.0073 sec   208 MBytes   174 Mbits/sec
[ 22] 0.0000-10.0145 sec   207 MBytes   174 Mbits/sec
[  9] 0.0000-10.0241 sec   208 MBytes   174 Mbits/sec
[ 17] 0.0000-10.0407 sec   225 MBytes   188 Mbits/sec
[  3] 0.0000-10.0382 sec   204 MBytes   170 Mbits/sec
[ 13] 0.0000-10.0296 sec   210 MBytes   176 Mbits/sec
[ 20] 0.0000-10.0621 sec   245 MBytes   205 Mbits/sec
[ 10] 0.0000-10.0416 sec   246 MBytes   205 Mbits/sec
[  7] 0.0000-10.0346 sec   208 MBytes   174 Mbits/sec
[ 12] 0.0000-10.0230 sec   208 MBytes   174 Mbits/sec
[ 18] 0.0000-10.0415 sec   204 MBytes   170 Mbits/sec
[  8] 0.0000-10.0408 sec   207 MBytes   173 Mbits/sec
[ 11] 0.0000-10.0562 sec   225 MBytes   188 Mbits/sec
[ 19] 0.0000-10.0533 sec   209 MBytes   175 Mbits/sec
[ 21] 0.0000-10.0116 sec   208 MBytes   174 Mbits/sec
[SUM] 0.0000-10.0119 sec  4.23 GBytes  3.63 Gbits/sec
[ CT] final connect times (min/avg/max/stdev) = 102.553/114.288/121.312/25.992 ms (tot/err) = 20/0
```
