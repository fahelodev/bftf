# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}${var.environment}-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space

  tags = {
    env = var.environment
  }
  depends_on = [azurerm_resource_group.barriofarma_rg]
 
}
resource "azurerm_subnet" "subnet1" {
  name                 = "${var.project_name}-subnet1"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes
}
resource "azurerm_subnet" "subnet2" {
  name                 = "${var.project_name}-subnet2"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes2
}
