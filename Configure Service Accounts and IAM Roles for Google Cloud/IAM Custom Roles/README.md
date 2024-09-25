# IAM Custom Roles
GSP190

https://www.cloudskillsboost.google/course_templates/702/labs/461622

https://www.cloudskillsboost.google/games/5426/labs/35177


## Set region
```
gcloud config set compute/region us-east1
```


In the Cloud IAM world, permissions are represented in the form:
```
- <service>.<resource>.<verb>
```

## Notes
For example, the **compute.instances.list** permission allows a user to list the Compute Engine instances they own, while **compute.instances.stop** allows a user to stop a VM.

Custom roles can only be used to grant permissions in policies for the same project or organization that owns the roles or resources under them. You cannot grant custom roles from one project or organization on a resource owned by a different project or organization.


### Required permissions and roles
To create a custom role, a caller must have the iam.roles.create permission.

Users who are not owners, including organization administrators, must be assigned either the Organization Role Administrator role (roles/iam.organizationRoleAdmin) or the IAM Role Administrator role (roles/iam.roleAdmin). The IAM Security Reviewer role (roles/iam.securityReviewer) enables the ability to view custom roles but not administer them.



## Task 1. View the available permissions for a resource
Before you create a custom role, you might want to know what permissions can be applied to a resource.

```
gcloud iam list-testable-permissions //cloudresourcemanager.googleapis.com/projects/$DEVSHELL_PROJECT_ID
```


## Task 2. Get the role metadata
```
gcloud iam roles describe roles/editor
gcloud iam roles describe roles/viewer
```

## Task 3. View the grantable roles on resources
```
gcloud iam list-grantable-roles //cloudresourcemanager.googleapis.com/projects/$DEVSHELL_PROJECT_ID
```


## Task 4. Create a custom role

### Create role with yml file - editor
```
nano role-definition.yaml

gcloud iam roles create editor --project $DEVSHELL_PROJECT_ID \
--file role-definition.yaml
```


### Create role with command - viewer
```
gcloud iam roles create viewer --project $DEVSHELL_PROJECT_ID \
--title "Role Viewer" --description "Custom role description." \
--permissions compute.instances.get,compute.instances.list --stage ALPHA
```


## Task 5. List the custom roles
https://console.cloud.google.com/iam-admin/roles


### list custom roles
```
gcloud iam roles list --project $DEVSHELL_PROJECT_ID
```

### list predefined roles
```
gcloud iam roles list

gcloud iam roles list --show-deleted
```



## Task 6. Update an existing custom role
### Update a custom role using a YAML file
First get the current state, update the changes and sync it
```
gcloud iam roles describe editor --project $DEVSHELL_PROJECT_ID > new-role-definition.yaml

sed -i '/includedPermissions:/a\  - storage.buckets.get\n  - storage.buckets.list' new-role-definition.yaml
sed -i '/appengine.versions.create/ s/^/  /; /appengine.versions.delete/ s/^/  /' new-role-definition.yaml

cat new-role-definition.yaml

gcloud iam roles update editor --project $DEVSHELL_PROJECT_ID \
--file new-role-definition.yaml
```


### Update a custom role using flags
```
gcloud iam roles update viewer --project $DEVSHELL_PROJECT_ID \
--add-permissions storage.buckets.get,storage.buckets.list
```


## Task 7. Disable a custom role
```
gcloud iam roles update viewer --project $DEVSHELL_PROJECT_ID \
--stage DISABLED
```


## Task 8. Delete a custom role
```
gcloud iam roles delete viewer --project $DEVSHELL_PROJECT_ID
```


## Task 9. Restore a custom role
```
gcloud iam roles undelete viewer --project $DEVSHELL_PROJECT_ID
```

