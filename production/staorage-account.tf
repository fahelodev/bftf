resource "random_integer" "this" {
  min = 10000
  max = 5000000
}

resource "azurerm_storage_account" "this" {
  name                     = "prodtest${random_integer.this.result}"
  resource_group_name      = azurerm_resource_group.barriofarma_rg.name
  location                 = azurerm_resource_group.barriofarma_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "this" {
  name                  = "prodtest"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "prodtest" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.production_uai.principal_id
}