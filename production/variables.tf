## azure barriofarma rg ##
variable client_id {
  type        = string
  description = "client_id"
}
variable client_secret {
  type        = string
  description = "client_secret"
}
variable project_name {
  type        = string
  description = "project name"
}
variable resource_group_name {
  description = "azure resources group"
  type        = string  
}
variable location {
  description = "location"
  type        = string
}
variable country {
  type        = string
  description = "description"
}
variable environment {
  type        = string
  description = "description"
}
## azure network ##
variable address_space {
  type        = list
  description = "address space"
}
variable address_prefixes {
  type        = list
  description = "address prefixes"
}
variable address_prefixes2 {
  type        = list
  description = "address prefixes2"
}
## azure aks ##
variable vm_size {
  type        = string
  description = "vm_size"
}
variable aks_version {
  type        = string
  description = "vm_size"
}


