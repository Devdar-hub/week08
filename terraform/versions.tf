terraform {
    required_version = ">= 1.7.0"

    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~> 4.0"
        }

        local = {
            source  = "hashicorp/local"
            version = "~> 2.5"
        }

        null = {
            source  = "hashicorp/null"
            version = "~> 3.2"
        }

        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = "~> 2.33"
        }
    }
}

provider "azurerm" {
    features {}
}

provider "kubernetes" {
    host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}