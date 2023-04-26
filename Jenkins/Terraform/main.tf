# Create an Azure resource group
data "azurerm_resource_group" "rg" {
  name     = var.resource_group
  
}

# Create an Azure virtual network  (like vpc in aws )
resource "azurerm_virtual_network" "virtual_network" {
  name                =  var.virtual_network
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

# # Create a subnet within the virtual network that is a  range  of ip in virtual network 
resource "azurerm_subnet" "subnetA" {
  name                 = var.SubnetName
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes       = ["10.0.1.0/24"]
}



# create public ip 

resource "azurerm_public_ip" "public_ip" {
  name                = var.NetworkInterface
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# # Create a network interface and associate it with the virtual machine's network interface
# Create Network Card for linux VM
resource "azurerm_network_interface" "NetworkInterface" {
  name                = "nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                           = "Internal"
    subnet_id                      = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
  depends_on = [
    azurerm_public_ip.public_ip
  ]
}

# Create a network security group
resource "azurerm_network_security_group" "firewall" {
  name                = "firewall11"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"  
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
  
  security_rule {
    name                       = "ui"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "jenkinsui"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
}

# Create a virtual machine
resource "azurerm_virtual_machine" "VM" {
  depends_on = [azurerm_network_interface.NetworkInterface]
  name                  = var.VM
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.NetworkInterface.id]
  vm_size               = "Standard_D2s_v3"

  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "7-LVM" 
    version   = "latest"
  }

  
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
    
  }
  
  
   os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = file(var.SshPath)
    }
  }

  tags = {
    environment = "production"
  }
} 

# attch security group
resource "azurerm_network_interface_security_group_association" "jenkins" {
  network_interface_id      = azurerm_network_interface.NetworkInterface.id
  network_security_group_id = azurerm_network_security_group.firewall.id
}
