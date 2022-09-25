# terraform-examples

## overview

This Repository demonstrates terraform in the style of my choice.

## After checkout this repo

You have to run following commands:

```bash
# Download the modules configured in main.tf. The -update parameter does update the modules to latest version
terraform get

# Quest: Have i to run terraform init each time?
# terraform init
```

## First Start

Configure the Backend in main.tf file for your need! 

~~Fill in the values for the environment variables in the [`.devcontainer/devcontainer.env` file](https://code.visualstudio.com/docs/remote/containers-advanced#_option-2-use-an-env-file)~~~
   - This file allows customization of the environment variables and the values needed for the terraform tasks.
   - 

## Help in progress

- https://github.com/microsoft/vscode-dev-containers/tree/v0.245.2/containers/azure-terraform
- [Terraform Website](https://www.terraform.io)
- [Azure DevOps Website](https://azure.microsoft.com/en-us/services/devops/)

**References**

- [Terraform Overview](https://www.terraform.io/intro/index.html)
- [Terraform Tutorials](https://learn.hashicorp.com/terraform?utm_source=terraform_io)
- [Terraform with Azure](https://docs.microsoft.com/en-us/azure/terraform/terraform-overview)
- [Terraform Extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- [Azure Terraform Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureterraform)

# az cheat sheet

```bash
# list locations
az account list-locations -o table

# list images of ubuntu
az vm image list --all --location westeurope -f ubuntu 

# list all package versions
apt list -a aziot-edge
```
