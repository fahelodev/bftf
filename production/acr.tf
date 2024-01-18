resource "azurerm_container_registry" "barriofarma_acr" {
  name                = "${var.project_name}${var.environment}acr"
  resource_group_name = azurerm_resource_group.barriofarma_rg.name
  location            = azurerm_resource_group.barriofarma_rg.location
  sku                 = "Premium"

  tags = { Name = "${var.project_name}${var.environment}acr"}
}

resource "azurerm_role_assignment" "acr_cicd_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.barriofarma_acr.id
  skip_service_principal_aad_check = true
}