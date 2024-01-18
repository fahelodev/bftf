# resource "azurerm_user_assigned_identity" "dev_test" {
#   name                = "dev-test"
#   location            = azurerm_resource_group.barriofarma_rg.location
#   resource_group_name = azurerm_resource_group.barriofarma_rg.name
# }

# resource "azurerm_federated_identity_credential" "dev_test" {
#   name                = "dev-test"
#   resource_group_name = azurerm_resource_group.barriofarma_rg.name
#   audience            = ["api://AzureADTokenExchange"]
#   issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
#   parent_id           = azurerm_user_assigned_identity.dev_test.id
#   subject             = "system:serviceaccount:dev:my-account"

#   depends_on = [azurerm_kubernetes_cluster.aks]
# }