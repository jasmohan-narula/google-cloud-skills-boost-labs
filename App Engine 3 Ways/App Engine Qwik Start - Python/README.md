# App Engine: Qwik Start - Python

https://www.cloudskillsboost.google/course_templates/671/labs/461532

GSP067


## Task 1. Enable Google App Engine Admin API
- In the left Navigation menu, click APIs & Services > Library.
- Type "App Engine Admin API" in the search box.
- Click the App Engine Admin API card.
- Click Enable. If there is no prompt to enable the API, then it is already enabled and no action is needed.

## Task 2. Download the Hello World app
```
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git

cd python-docs-samples/appengine/standard_python3/hello_world

sudo apt install python3 -y
sudo apt install python3.11-venv
python3 -m venv create myvenv
source myvenv/bin/activate
```

## Task 3. Test the application
```
dev_appserver.py app.yaml
```

View the results by clicking the Web preview (web preview icon) > Preview on port 8080.

## Task 4. Make a change
```
cd python-docs-samples/appengine/standard_python3/hello_world
nano main.py
```
Change "Hello World!" to "Hello, Cruel World!".

Save the file with CTRL-S and exit with CTRL-X.

Reload the Hello World! Browser or click the Web Preview (web preview icon) > Preview on port 8080 to see the results.


## Task 5. Deploy your app

To deploy your app to App Engine, run the following command from within the root directory of your application where the app.yaml file is located:
```
gcloud app deploy
```

Enter the number that represents your region: europe-west
```
7
```

The App Engine application will then be created.

Enter Y when prompted to confirm the details and begin the deployment of service.


## Task 6. View your application
```
gcloud app browse
```
- https://qwiklabs-gcp-01-1bf82248d180.ew.r.appspot.com/


## Task 7. Test your knowledge - Quiz

With Google App Engine, what do developers need to focus on?
- Application code

What modern language runtimes are supported by App Engine?
- Ruby
- Java
- Python
- PHP
- Node.js (JavaScript)
- Go


What are other serverless platforms from Google Cloud that are similar to App Engine?
- Cloud Functions
- Cloud Run

