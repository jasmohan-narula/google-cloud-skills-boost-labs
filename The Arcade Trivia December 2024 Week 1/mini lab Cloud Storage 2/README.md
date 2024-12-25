# mini lab : Cloud Storage : 2

https://www.cloudskillsboost.google/games/5699/labs/36422

## Challenge scenario
You are managing a Cloud Storage bucket named BUCKET_NAME. This bucket serves multiple purposes within your organization and contains a mix of active project files, archived documents, and temporary logs. To optimize storage costs, you need to implement a lifecycle management policy that automatically aligns the storage classes of these files with their access patterns.

Design a lifecycle management policy with the following objectives:

- Active Project Files: Files within the /projects/active/ folder modified within the last 30 days should reside in Standard storage for fast access.
- Archives: Files within /archive/ modified within the last 90 days should be moved to Nearline storage. After 180 days, they should transition to Coldline storage.
- Temporary Logs: Files within /processing/temp_logs/ should be automatically deleted after 7 days.


## Solution
```
cat > lifecycle.json << EOF
{
    "rule": [
      {
        "action": {
          "storageClass": "STANDARD",
          "type": "SetStorageClass"
        },
        "condition": {
          "daysSinceNoncurrentTime": 30,
          "matchesPrefix": ["projects/active/"]
        }
      },

      {
        "action": {
          "storageClass": "NEARLINE",
          "type": "SetStorageClass"
        },
        "condition": {
          "daysSinceNoncurrentTime": 90,
          "matchesPrefix": ["archive/"]
        }
      },
      {
        "action": {
          "storageClass": "COLDLINE",
          "type": "SetStorageClass"
        },
        "condition": {
          "daysSinceNoncurrentTime": 180,
          "matchesPrefix": ["archive/"]
        }
      },


      {
        "action": {
          "type": "Delete"
        },
        "condition": {
          "age": 7,
          "matchesPrefix": ["processing/temp_logs/"]

        }
      }

    ]
  }
EOF


export PROJECT_ID=$(gcloud config get-value project)
export BUCKET_NAME=$PROJECT_ID-bucket
echo $BUCKET_NAME

gsutil lifecycle set lifecycle.json gs://$BUCKET_NAME
```