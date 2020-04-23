# GCP lab 2

## Objectives

1. Build docker image with simple apache and static web page locally
2. Provision GKE cluster manually and deploy image manually
3. Provision GKE cluster using Terraform from local
4. Deploy image into the cluster using Kubernetes manifests from local
5. Create build and deploy pipeline using Cloud Build

Below information assumes that the first two objectives are already completed. 

### Directory structure
* ./terraform - Terraform files
* ./k8s - Kubernetes manifests
* ./docker - Dockerfile
* ./public-html - Static web page


### Create GCP project and setup Terraform
* Follow Hashicorp training: https://learn.hashicorp.com/terraform/gcp/intro
* Follow Google Terraform documentation: https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform
* Do not store credentials file inside the repo

### Environment variables
If using Makefile, set local environment variables in .env file. Rename template.env into .env and set variables.
```bash
PROJECT_ID=gcp_project_id
CLUSTER=gke_cluster_name
TF_STATE_BUCKET=terraform_state_bucket
GOOGLE_APPLICATION_CREDENTIALS=path_to_gcp_creds_file
```
Alternatively set variables directly inside shell.

### Deploy from local using Makefile
Once GCP project and Terraform are setup run the following to provision GKE cluster and deploy app.
* Run 
    ```bash
    make provision
    ```
* Tear down
    ```
    make destroy
    ```
Alternatively run commands from Makefile.

### Local vs Remote state for Terraform
By default Terraform state will be local. In this lab we create remote state in GCP storage bucket.
* Create storage bucket for terraform state
    ```bash
    gsutil mb -c standard -l us-central1 gs://globaly-unique-bucket-name
    ```
* Run 
    ```bash
    terraform init
    ```


## CI/CD

Now we can use Cloud Build to deploy the app.

The first stage is to provision GKE cluster, then deploy the app. We describe it inside cloudbuild.yaml

* Connect your github repo to Cloud Repo.
* Make sure that Cloud Build service account has enough permissions for Kubernetes Engine and Compute Engine. Use Cloud Build Settings and IAM console to configure.
* Go to Code Build and create a push trigger for the repo
* Now every git push should trigger a build. Watch logs.