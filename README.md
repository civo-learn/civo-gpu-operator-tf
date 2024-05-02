
# Project Name: Nvida GPU Operator for Civo

## Introduction

This project provides a boilerplate for deploying a K8s GPU Cluster on Civo Cloud using Terraform. It automates the setup of the [Nvidia GPU Operator](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/latest/index.html) on the Civo Talos Linux GPU Clusters

## Prerequisites

Before beginning, ensure you have the following:

- A [Civo Cloud account](https://dashboard.civo.com/signup).
- A [Civo Cloud API Key](https://dashboard.civo.com/security).
- [Terraform](https://developer.hashicorp.com/terraform/install) installed on your local machine.

## Project Setup

1. Obtain your Civo API key from the Civo Cloud dashboard.
2. Create a file named `terraform.tfvars` in the project's root directory.
3. Insert your Civo API key into this file as follows:

    ```hcl
    civo_token = "YOUR_API_KEY"
    ```

## Project Configuration

Project configurations are managed within the `tf/variables.tf` file. This file contains definitions and default values for the Terraform variables used in the project.

| Variable             | Description                                       | Type   | Default Value      |
|----------------------|---------------------------------------------------|--------|--------------------|
| `cluster_name`       | The name of the cluster.                          | string | "llm_cluster3"     |
| `cluster_node_size`  | The GPU node instance to use for the cluster.     | string | "g4g.40.kube.small" |
| `cluster_node_count` | The number of nodes to provision in the cluster.  | number | 1                  |
| `civo_token`         | The Civo API token, set in terraform.tfvars.      | string | N/A                |
| `region`             | The Civo Region to deploy the cluster in.         | string | "LON1"             |

## Deploy Nvidia GPU Operator

To deploy, simply run the following commands:

1. **Initialize Terraform:**

    ```
    terraform init
    ```

    This command initializes Terraform, installs the required providers, and prepares the environment for deployment.

2. **Plan Deployment:**

    ```
    terraform plan
    ```

    This command displays the deployment plan, showing what resources will be created or modified.

3. **Apply Deployment:**

    ```
    terraform apply
    ```

    This command applies the deployment plan. Terraform will prompt for confirmation before proceeding with the creation of resources.

