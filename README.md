# Provision Hosted Clusters (EKS, GKE, AKS) for Rancher Management

This repository contains Terraform source code to provision EKS, GKE and AKS Kubernetes clusters. The folder *eks-clusters* contains code for two clusters to be created. One will be used for installing Rancher. To install Rancher on an EKS cluster, you can follow the steps in the Rancher documentation found [here](https://rancher.com/docs/rancher/v2.6/en/installation/install-rancher-on-k8s/amazon-eks/) from step 5. 

*You don't have to be a Terraform expert to carry out the steps below. All the relevant source code is set up for the EKS, GKE and AKS clusters to be provisioned in the respective cloud environments.*

## Amazon EKS Clusters

## Prerequisites
* AWS account
* AWS profile configured with [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) on local machine
* [Terraform](https://www.terraform.io/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Project Structure

```
├── README.md
├── eks
|  ├── cluster.tf
|  ├── cluster_role.tf
|  ├── cluster_sg.tf
|  ├── node_group.tf
|  ├── node_group_role.tf
|  ├── node_sg.tf
|  └── vars.tf
├── main.tf
├── provider.tf
├── raw-manifests
|  ├── aws-auth.yaml
|  ├── pod.yaml
|  └── service.yaml
├── variables.tf
└── vpc
   ├── control_plane_sg.tf
   ├── data_plane_sg.tf
   ├── nat_gw.tf
   ├── output.tf
   ├── public_sg.tf
   ├── vars.tf
   └── vpc.tf
```

## Remote Backend State Configuration
To configure remote backend state for your infrastructure, create an S3 bucket before running *terraform init*. In the case that you want to use local state persistence, update the *provider.tf* accordingly and don't bother with creating an S3 bucket and DynamoDB table.

### Create S3 Bucket for State Backend
```aws s3api create-bucket --bucket <unqiue-name> --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1 ```
*NB: The bucket name you choose should be globally unique.*

## Provision Infrastructure
Review the *main.tf* to update the node size configurations (i.e. desired, maximum, and minimum). When you're ready, run the following commands:
1. `terraform init` - Initialize the project, setup the state persistence (whether local or remote) and download the API plugins.
2. `terraform plan` - Print the plan of the desired state without changing the state.
3. `terraform apply` - Print the desired state of infrastructure changes with the option to execute the plan and provision. 

## Connect To Cluster
Using the same AWS account profile that provisioned the infrastructure, you can connect to your cluster by updating your local kube config with the following command:
`aws eks --region <aws-region> update-kubeconfig --name <cluster-name>`

## Map IAM Users & Roles to EKS Cluster
If you want to map additional IAM users or roles to your Kubernetes cluster, you will have to update the `aws-auth` *ConfigMap* by adding the respective ARN and a Kubernetes username value to the mapRole or mapUser property as an array item. 

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::<aws-account-id>:role/alpha-worker
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
  mapUsers: |
    - userarn: arn:aws:iam::<aws-account-id>:user/iam-user
      username: iam-user
      groups:
        - system:masters
```

When you are done with modifications to the aws-auth ConfigMap, you can run `kubectl apply -f auth-auth.yaml`. An example of this manifest file exists in the eks-clusters/manifests directory.

For a more in-depth explanation on this, you can read [this post](https://medium.com/swlh/secure-an-amazon-eks-cluster-with-iam-rbac-b78be0cd95c9).

## View Existing Workloads
`kubectl get pods --all-namespaces`

---

## Microsoft Azure AKS Cluster

## Prerequisites
* Azure account
* Azure profile configured with [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) on local machine
* [Terraform](https://www.terraform.io/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Project Structure
```
├── README.md
├── aks
|  ├── cluster.tf
|  └── variables.tf
├── main.tf
└── provider.tf
```

### Authenticate to Azure using the CLI
The next step after installation is to authenticate to Azure, which can be done using the CLI. Run the following command and your default browser will open for you to sign into Azure with a Microsoft account.
```
az login
```
You can then view account details with the following command:
```
az account list
```
This will output something similar to the following:
```
[
  {
    "cloudName": "AzureCloud",
    "id": "00000000-0000-0000-0000-000000000000",
    "isDefault": true,
    "name": "PAYG Subscription",
    "state": "Enabled",
    "tenantId": "00000000-0000-0000-0000-000000000000",
    "user": {
      "name": "user@example.com",
      "type": "user"
    }
  }
]
```
The `id` field is the `subscription_id`. The Subscription ID is a GUID that uniquely identifies your subscription to use Azure services. If you have multiple subscriptions, you can set the one you want to use with the following command:
```
az account set --subscription="SUBSCRIPTION_ID"
```

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

## Connect to AKS Cluster
Using the same Azure account profile that provisioned the infrastructure, you can connect to your cluster by updating your local kube config with the following command:
```
az aks get-credentials --resource-group <resource-group-name> --name <cluster-name>
```

## View Existing Workloads
`kubectl get pods --all-namespaces`

---

## GCP GKE Cluster

## Prerequisites
* GCP account
* [Google Cloud SDK & CLI](https://cloud.google.com/sdk/docs/install)
* [Terraform](https://www.terraform.io/)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Authenticate to GCP using the CLI
If you are using terraform on your workstation, you will need to install the Google Cloud SDK and authenticate using User Application Default Credentials by running the command `gcloud auth application-default login`. 

## Project Structure

```
├── README.md
├── gke
|  ├── gke-cluster.tf
|  └── variables.tf
├── main.tf
└── provider.tf
```

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

---

## Delete Provisioned Infrastructure
Once you are done with the infrastructure, remember to destroy it with the `terraform destroy -auto-approve` command in each of the respective directories. The *-auto-approve* flag will skip the step of telling you what will be destroyed. The project is structured to destroy everything that is provisioned.

Repeat these steps for each of the folders.
```
cd <directory> # i.e. eks-clusters
terraform destroy -auto-approve
```

## Potential Issues
If you provision additional infrastructure such as Load Balancers that is not declared in this source code, you might run into issues when attempting to delete resources that would require those additional resources to be deleted first. This project is structured to provision and delete what has been declared. Make sure you delete any additional resources that you create.