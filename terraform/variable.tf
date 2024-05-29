

variable "resource_group_name" {
  description = "provide your resource group name here" 
  type = string
  default     = "AAP-installation"
}

variable "resource_group_location" {
  description = "provide your resource group location here" 
  type = string
  default     = "eastus"
}

variable "virtual_network_name" {
  description = "provide your vnet name "
    type        = string
  default     = "AAP-network"
}

variable "virtual_address_space" {
  description = "List of address spaces for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "Nic" {
  description = "provide your network interface name"
    type        = string
  default     = "Nic"
}

variable "virtual_machine_name" {
    description = "provide your virtuval machine name"
    type        = string
    default     = "AAP-vm"
  
}
variable "public_ip_name" {
   description = "provide your virtuval machine name"
    type        = string
    default     = "AAP-ip"
}
variable "Nsg" { 
   description = "provide your Network security group name"
    type        = string
    default     = "AAP-vm"
}
variable "network_interface_internal" {
   description = "provide your network interface internal name"
    type        = string 
    default     = "AAP-nic"
  
}

variable "subnet_name" {
   description = "provide your subnet name"
    type        = string 
    default     = "AAP-subnet"
}

variable "subnet_address_space" {
    description = "List of address spaces for the subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}