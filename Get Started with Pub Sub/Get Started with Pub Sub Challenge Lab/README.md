# Get Started with Pub/Sub: Challenge Lab

ARC113

https://www.cloudskillsboost.google/course_templates/728/labs/461595


#
Region - **us-east1**


Note: You've been assigned random tasks from the set of tasks. Please reference this Form ID: form-1 and respective Task Number while reporting any issues, requesting assistance with these tasks or providing any feedback.


## Task 1
Set up Cloud Pub/Sub
1. Create a Cloud Pub/Sub topic 'cloud-pubsub-topic'.
2. Create a Cloud Pub/Sub subscription 'cloud-pubsub-subscription' for a given topic 'cloud-pubsub-topic'.

```
gcloud config set compute/region us-east1

gcloud pubsub topics create cloud-pubsub-topic

gcloud pubsub subscriptions create cloud-pubsub-subscription --topic cloud-pubsub-topic
```





## Task 2
Create a Cloud Scheduler job
1. Create a Cloud Scheduler job using the following details:

| Parameter         | Configuration                                                                                          |
|-------------------|--------------------------------------------------------------------------------------------------------|
| **Name**          | cron-scheduler-job                                                                                     |
| **Location**      | Region from the Lab Details panel which is located at the left side of the lab instructions            |
| **Schedule**      | Sends a message to your Cloud Pub/Sub topic every minute: `* * * * *`                                  |
| **Topic**         | cron-job-pubsub-topic                                                                                  |
| **Message body**  | Hello World!                                                                                           |

| Parameter         | Configuration                                                                                          |
|-------------------|--------------------------------------------------------------------------------------------------------|
| **Timezone**          | IST (Indian Standard Time)                                                                            |
| **Execution Target Type** | Pub/Sub                                                                                           |



## Task 3
Verify the results in Cloud Pub/Sub
1. For this task, you need to verify that Cloud Pub/Sub is able to pull the messages you have published via Cloud Scheduler with the following command:
```
gcloud pubsub subscriptions pull cron-job-pubsub-subscription --limit 5
```



