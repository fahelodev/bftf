# workload identity : sirve para mapear algun rol de azure a algun pod en particular
resource "azurerm_user_assigned_identity" "dev_test" {
  name                = "dev-test"
  location            = azurerm_resource_group.barriofarma_rg.location
  resource_group_name = azurerm_resource_group.barriofarma_rg.name
}

# credenciales del recurso
resource "azurerm_federated_identity_credential" "dev_test" {
  name                = "dev-test"
  resource_group_name = azurerm_resource_group.barriofarma_rg.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url #openid en aks
  parent_id           = azurerm_user_assigned_identity.dev_test.id
  subject             = "system:serviceaccount:dev:my-account" # sys:sa:namespace:k8sa

  depends_on = [azurerm_kubernetes_cluster.aks]
}