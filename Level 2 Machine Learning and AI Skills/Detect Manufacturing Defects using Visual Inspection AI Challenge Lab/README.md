# Detect Manufacturing Defects using Visual Inspection AI: Challenge Lab


## Task 1. Deploy the exported Cosmetic Inspection anomaly detection solution artifact

Connect to the Compute Engine instance called lab-vm using SSH. The VM is located in the us-west1-c zone.

The exported solution artifact container uses port 8601 for grpc traffic, port 8602 for http traffic, and port 8603 for Prometheus metric traffic. You can map these ports to locally available ports in the virtual machine instance environment when starting the container with Docker using the command line switches -v 9000:8602 or -v 3006:8603.

You must now deploy the exported solution container that was prepared for you in order to test it by downloading and running it locally in the Compute Engine virtual machine instance with the following configurations:

- Container name	product_inspection
- Container Registry location	gcr.io/ql-shared-resources-test/defect_solution@sha256:776fd8c65304ac017f5b9a986a1b8189695b7abbff6aa0e4ef693c46c7122f4c


```
docker --version

export CONTAINER_REGISTRY_LOCATION=gcr.io/ql-shared-resources-test/defect_solution@sha256:776fd8c65304ac017f5b9a986a1b8189695b7abbff6aa0e4ef693c46c7122f4c
echo $CONTAINER_REGISTRY_LOCATION

docker pull $CONTAINER_REGISTRY_LOCATION

docker run -d --name product_inspection \
  -p 9000:8602 \
  -p 3006:8603 \
  $CONTAINER_REGISTRY_LOCATION

docker container ls
```


## Task 2. Prepare resources to serve the exported assembly inspection solution artifact

### Copy the prediction script
```
gsutil cp gs://cloud-training/gsp895/prediction_script.py .
```

The Python script takes the following parameters that must be set correctly when executing it:
- --input_image_file	Path to the image file to run predictions against.
- --port	The port for http traffic.
- --output_result_file	Path to the output file containing predictions.

### Create a Cloud Storage bucket and copy images to it
Create a Cloud Storage bucket named qwiklabs-gcp-04-c02f56b0a50d.

Using Cloud Shell
```
gsutil mb -l us-west1 gs://qwiklabs-gcp-04-c02f56b0a50d/
```

You can access it on
- https://console.cloud.google.com/storage/browser/qwiklabs-gcp-04-c02f56b0a50d


Copy the folder containing the images of your product to your bucket from the following location: gs://cloud-training/gsp897/cosmetic-test-data into a folder called /cosmetic-test-data in your Cloud Storage bucket.

Using VM
```
gsutil cp -r gs://cloud-training/gsp897/cosmetic-test-data gs://qwiklabs-gcp-04-c02f56b0a50d/cosmetic-test-data
```


## Task 3. Identify a defective product image

Store the prediction result that identifies a defective product in a file called defective_product_result.json stored in the HOME directory of your Compute Engine virtual machine.

Two files that you should focus on are IMG_0769.png and IMG_07703.png.

```
pip install requests absl-py numpy
```

```
gsutil cp gs://qwiklabs-gcp-04-c02f56b0a50d/cosmetic-test-data/IMG_0769.png /tmp/IMG_0769.png
gsutil cp gs://qwiklabs-gcp-04-c02f56b0a50d/cosmetic-test-data/IMG_07703.png /tmp/IMG_07703.png

python3 prediction_script.py \
  --input_image_file=/tmp/IMG_0769.png \
  --output_result_file=defective_product_result_0769.json \
  --port=9000


python3 prediction_script.py \
  --input_image_file=/tmp/IMG_07703.png \
  --output_result_file=defective_product_result_07703.json \
  --port=9000
```

```
cp defective_product_result_07703.json defective_product_result.json
```


## Task 4. Identify a non-defective product

Store the prediction result that identifies a non-defective product in a file called non_defective_product_result.json stored in the HOME directory of your Compute Engine virtual machine.

```
cp defective_product_result_0769.json non_defective_product_result.json
```