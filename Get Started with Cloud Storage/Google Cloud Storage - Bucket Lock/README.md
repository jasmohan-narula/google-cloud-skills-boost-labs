# Google Cloud Storage - Bucket Lock

https://www.cloudskillsboost.google/course_templates/725/labs/461638

GSP297

Cloud Storage Bucket Lock feature which allows you to configure a data retention policy for a Cloud Storage bucket that governs how long objects in the bucket must be retained. The feature also allows you to lock the data retention policy, permanently preventing the policy from being reduced or removed.



## Task 1. Create a new bucket
export BUCKET=$(gcloud config get-value project)
gsutil mb "gs://$BUCKET"

## Task 2. Define a Retention Policy
Consider a financial institution branch with a SEC Rule 17a-4 requirement to retain financial transaction records for 6 years (10 seconds for this lab)
```
gsutil retention set 10s "gs://$BUCKET"
```

**Note: You can also use 10d for 10 days, 10m for 10 months or 10y for 10 years. To learn more, use the command: gsutil help retention set.**

Verify
```
gsutil retention get "gs://$BUCKET"

> Retention Policy (UNLOCKED):
    Duration: 10 Second(s)
    Effective Time: Fri, 20 Sep 2024 19:38:00 GMT

gsutil cp gs://spls/gsp297/dummy_transactions "gs://$BUCKET/"

gsutil ls -L "gs://$BUCKET/dummy_transactions"
> gs://qwiklabs-gcp-01-ff5273045e42/dummy_transactions:
    Creation time:          Fri, 20 Sep 2024 19:37:35 GMT
    Update time:            Fri, 20 Sep 2024 19:37:35 GMT
    Storage class:          STANDARD
    Retention Expiration:   Fri, 20 Sep 2024 19:37:45 GMT

```


## Task 3. Lock the Retention Policy
While unlocked, you can remove the Retention Policy from the bucket or reduce the retention time. After you lock the Retention Policy, it cannot be removed from the bucket or the retention time reduced.

Once locked the Retention Policy can't be unlocked and can only be extended. The Effective Time is updated if the amount of time since it was set or last updated has exceeded the Retention Policy.

```
gsutil retention lock "gs://$BUCKET/"
> This will PERMANENTLY set the Retention Policy on gs://qwiklabs-gcp-01-ff5273045e42 to:

  Retention Policy (UNLOCKED):
    Duration: 10 Second(s)
    Effective Time: Fri, 20 Sep 2024 19:38:00 GMT

This setting cannot be reverted!  Continue? [y|N]: y
Locking Retention Policy on gs://qwiklabs-gcp-01-ff5273045e42/...
```


## Task 4. Temporary hold
Financial regulators decide to perform an audit of one of the branch's customers, and require that those records are retained for the duration of the audit. Some of the Cloud Storage objects for this customer are close to their expiration date, and will soon be automatically deleted.

To handle this, when regulatory investigation begins, the Branch IT Administrator sets the temporary hold flag for each of the objects related to the audit. While that flag is set, the objects will continue to be protected from deletion, even if they are older than 10 seconds.

By placing a temporary hold on the object, delete operations are not possible unless the object is released from the hold. As an example, attempt to delete the object:

```
gsutil retention temp set "gs://$BUCKET/dummy_transactions"

gsutil rm "gs://$BUCKET/dummy_transactions"
> Removing gs://qwiklabs-gcp-01-ff5273045e42/dummy_transactions...
AccessDeniedException: 403 Object 'qwiklabs-gcp-01-ff5273045e42/dummy_transactions' is under active Temporary hold and cannot be deleted, overwritten or archived until hold is removed.
```

Release the hold
```
gsutil retention temp release "gs://$BUCKET/dummy_transactions"
```

## Task 5. Event-based holds
```
gsutil retention event-default set "gs://$BUCKET/"

gsutil cp gs://spls/gsp297/dummy_loan "gs://$BUCKET/"

gsutil ls -L "gs://$BUCKET/dummy_loan"
> gs://qwiklabs-gcp-01-ff5273045e42/dummy_loan:
    Creation time:          Fri, 20 Sep 2024 19:46:09 GMT
    Update time:            Fri, 20 Sep 2024 19:46:09 GMT
    Storage class:          STANDARD
    Event-Based Hold:       Enabled

gsutil retention event release "gs://$BUCKET/dummy_loan"
```