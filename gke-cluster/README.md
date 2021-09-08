# GCP GKE Clusters
First, authenticate with GCP. The easiest way to do this is to run gcloud auth application-default login, if you already have gcloud installed. 

## Prerequisites
* GCP account
* [Google Cloud SDK & CLI](https://cloud.google.com/sdk/docs/install)
* [Terraform](https://www.terraform.io/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Project Structure

```
├── README.md
├── gke
|  ├── gke-cluster.tf
|  └── variables.tf
├── main.tf
└── provider.tf
```

## Authenticate to GCP using the CLI
If you are using terraform on your workstation, you will need to install the Google Cloud SDK and authenticate using User Application Default Credentials by running the command `gcloud auth application-default login`.

## Remote Backend State Configuration
To configure remote backend state for your infrastructure, create an S3 bucket and DynamoDB table before running *terraform init*. In the case that you want to use local state persistence, update the *provider.tf* accordingly and don't bother with creating an S3 bucket and DynamoDB table.

### Create S3 Bucket for State Backend
```aws s3api create-bucket --bucket <unique-name> --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1 ```
*NB: The bucket name you choose should be globally unique.*

## Provision Infrastructure
Review the *main.tf* to update the node size configurations (i.e. desired, maximum, and minimum). When you're ready, run the following commands:
1. `terraform init` - Initialize the project, setup the state persistence (whether local or remote) and download the API plugins.
2. `terraform plan` - Print the plan of the desired state without changing the state.
3. `terraform apply` - Print the desired state of infrastructure changes with the option to execute the plan and provision. 

## Connect To Cluster
Using the same GCP account profile that provisioned the infrastructure, you can connect to your cluster by updating your local kube config with the following command:
```
gcloud container clusters get-credentials beta --region europe-west1 --project your-account-id/project
```