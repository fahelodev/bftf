resource "azurerm_resource_group" "barriofarma_rg" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_user_assigned_identity" "base" {
  name                = "base"
  location            = azurerm_resource_group.barriofarma_rg.location
  resource_group_name = azurerm_resource_group.barriofarma_rg.name
}

resource "azurerm_role_assignment" "base" {
  scope                = azurerm_resource_group.barriofarma_rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.base.principal_id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}${var.environment}-aks"
  location            = azurerm_resource_group.barriofarma_rg.location
  resource_group_name = azurerm_resource_group.barriofarma_rg.name
  dns_prefix          = "${var.project_name}${var.environment}1"
  # For prod change to "Standard"
  sku_tier                  = "Free"
  #variables para permitir conexiones oidc y workload identity
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  automatic_channel_upgrade = "stable"
  private_cluster_enabled   = false
  node_resource_group       = "${var.project_name}${var.environment}-aks" #esto crea un resources group con todo lo de aks


  default_node_pool {
    name                  = "general"
    vm_size               = "Standard_DS2_v2"
    vnet_subnet_id        = azurerm_subnet.subnet1.id
    type                  = "VirtualMachineScaleSets"
    enable_auto_scaling   = true
    node_count            = 1
    min_count             = 1
    max_count             = 10

    node_labels = {
      role = "general" #node migration
    }
  }

  # service_principal {
  #   client_id     = var.client_id
  #   client_secret = var.client_secret
  # }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "calico"
    service_cidr       = "10.0.64.0/19"
    dns_service_ip     = "10.0.64.10"    
  }

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.base.id]
  }

  tags ={
    env = var.environment
  }

   lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }

  depends_on = [
    azurerm_virtual_network.vnet
  ]

}

resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_DS2_v2"
  vnet_subnet_id        = azurerm_subnet.subnet1.id
  priority              = "Spot"
  spot_max_price        = -1
  eviction_policy       = "Delete"

  enable_auto_scaling = true
  node_count          = 1
  min_count           = 1
  max_count           = 10

  node_labels = {
    role                                    = "spot"
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }

  node_taints = [
    "spot:NoSchedule",
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]

  tags = {
    env = var.environment
  }

  lifecycle {
    ignore_changes = [node_count]
  }
}
