# monitoring.tf
# Infrastructure-as-Code addition for Task 10.2D.
# Provisions a Log Analytics workspace and enables Container Insights on the
# existing AKS cluster. Prometheus and Grafana Kubernetes resources are
# deployed later by Helm and kubectl after AKS exists.
#
# Assumes your existing Terraform config already defines:
#   - azurerm_resource_group.rg          (dar-week08-v1-rg / Australia East)
#   - azurerm_kubernetes_cluster.aks
#   - variable "tags" (as set in your terraform.tfvars)
#   - a configured azurerm provider
# If your resource labels in main.tf differ from azurerm_resource_group.rg /
# azurerm_kubernetes_cluster.aks, update the references below to match.

resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = "dar81v1-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics" {
  name                       = "aks-diagnostics"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.monitoring.id

  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.monitoring.id
}
