

## Azure Main Resource Group Creation
resource "azurerm_resource_group" "rg" {
  name     =  var.resource_group_name
  location = var.resource_group_location
}

## Azure Main Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = var.virtual_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}



# ## Azure Network Interface
resource "azurerm_network_interface" "main" {
  name                = var.Nic
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
 
}

# ## Azure Network Internal Interface
resource "azurerm_network_interface" "internal" {
  name                = var.network_interface_internal
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

#   tags = {
#     environment = "Production"
#   }
}

# ## Azure subnet
resource "azurerm_subnet" "internal" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_space
}

# ## Public IP Address
resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"

}

# ## Azure Network Security Group [NSG]
resource "azurerm_network_security_group" "nsg" {
  name                = var.Nsg
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "tls"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }

 
}

# ## Azure Network Security Group Association [NSG]
resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.internal.id
  network_security_group_id = azurerm_network_security_group.nsg.id
 }
# ## Create unique password
   resource "random_password" "password" {

      length           = 16
      special          = true
      min_special      = 2
      override_special = "*!@#?"
   }
# ## Azure Linux Virtual Machine for Ansible Main Node Deployment
resource "azurerm_linux_virtual_machine" "main" {
  name                            = var.virtual_machine_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_D2s_v3"  
  admin_username                  = "eca-ansible"
  admin_password                  = random_password.password.result
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.main.id
    # azurerm_network_interface.internal.id
  ]


  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "92-gen2"
    version   = "latest"
  }

  os_disk {

    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"

  }

#   tags = {
#     environment = "Production"
#   }

   connection {
      host = self.public_ip_address
      type     = "ssh"
      user     = "eca-ansible"
      password = random_password.password.result
     agent = false
    }


#   provisioner "remote-exec" {

#     inline = [
#       "cd /tmp",
#       " wget 'https://access.cdn.redhat.com/content/origin/files/sha256/ef/ef711fca2e43bcae5c525396a8620953cbbfc8620b3e939e15b97e88aea7b020/ansible-automation-platform-setup-bundle-2.2.2-1.1.tar.gz?user=6c3b06de8d9e8a1fc50028c012bfe147&_auth_=1693490473_3d79eec069f37870d16dc8c57c5e3e32' ",
#       "sleep 3m ",
#       "sudo mv ansible* bundel.gz ",
#       " sudo mv bundel.gz /var/",
#       "cd /var/",
#       "sudo tar -xvzf /var/bundel.gz",
#       "cd /var/ansible*/",
#       "sudo cp inventory  inventory-backup",
#       "sudo sed -i '/^\\[automationcontroller\\]$/a ${self.public_ip_address} ansible_connection=local' /var/ansible*/inventory",
#       "sudo sed -i 's/pg_password=.*/pg_password= 'password'/' /var/ansible*/inventory" ,
#       "sudo sed -i 's/admin_password=.*/admin_password= 'password'/' /var/ansible*/inventory" ,

#       "sudo sh setup.sh"
       
#     ]  
#   }

 } 







