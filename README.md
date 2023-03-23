---
page_type: sample
languages:
- azurecli
- bash
- terraform
- yaml
- json
products:
- azure
- azure-container-apps
- azure-storage
- azure-blob-storage
- azure-storage-accounts
- azure-monitor
- azure-log-analytics
- azure-application-insights

name:  Configure AAD with an Azure Red Hat OpenShift cluster using Terraform and AzAPI Provider
description: This sample shows how to confugre AAD with an Azure Red Hat OpenShift cluster using Terraform and AzAPI Provider for authentication and rbac.
urlFragment: aro-aad-terraform
---

# Import ARO cluster in terraform.

## Prerequisites

- If you want to run Azure CLI locally, install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- An Azure account with an active subscription is required. If you don't already have one, you can [create an account for free](https://azure.microsoft.com/free/?WT.mc_id=A261C142F). If you don't have one, create a [free Azure account](https://azure.microsoft.com/free/) before you begin.
- [Visual Studio Code](https://code.visualstudio.com/) installed on one of the [supported platforms](https://code.visualstudio.com/docs/supporting/requirements#_platforms) along with the [HashiCorp Terraform](hhttps://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform).
- Ability to assign User Access Administrator and Contributor roles. If you lack this ability, contact your Azure Active Directory admin to manage roles.
- A Red Hat account. If you don't have one, you'll have to [register for an account](https://www.redhat.com/wapps/ugc/register.html).
- A pull secret for your Azure Red Hat OpenShift cluster. [Download the pull secret file from the Red Hat OpenShift Cluster Manager web site](https://cloud.redhat.com/openshift/install/azure/aro-provisioned).
- If you want to run the Azure PowerShell code locally, [Azure PowerShell](/powershell/azure/install-az-ps).
- Create an ARO cluster. Follow the [instructions] (https://github.com/sgahlot/aro-azapi-terraform)

## Import aro cluster.
- Login to azure
```
az login
```
- Initialize terraform
```
terraform init
```
- Run the command.
```
export subscription_id=<<subscription_id>>
export name_prefix=<<name_prefix>>
export resource_group_name=<<resource_group_name>>
export aro_cluster_name=<<aro_cluster_name>>
terraform import  -var "name_prefix=$name_prefix" -var "cluster_name=$aro_cluster_name" -var "resource_group_name=$resource_group_name"  azapi_resource.aro_cluster /subscriptions/$subscription_id/resourceGroups/$resource_group_name/providers/Microsoft.RedHatOpenShift/OpenShiftClusters/$aro_cluster_name
```
- Uncomment the code in import.tf
- Terraform apply
```
terraform apply  -var "name_prefix=$name_prefix" -var "cluster_name=$aro_cluster_name" -var "resource_group_name=$resource_group_name"
```
