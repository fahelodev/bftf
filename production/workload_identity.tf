resource "azurerm_user_assigned_identity" "production_uai" {
  name                = "production_uai"
  location            = azurerm_resource_group.barriofarma_rg.location
  resource_group_name = azurerm_resource_group.barriofarma_rg.name
}

resource "azurerm_federated_identity_credential" "production_uai" {
  name                = "production_uai"
  resource_group_name = azurerm_resource_group.barriofarma_rg.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.production_uai.id
  subject             = "system:serviceaccount:production_uai:my-account"

  depends_on = [azurerm_kubernetes_cluster.aks]
}