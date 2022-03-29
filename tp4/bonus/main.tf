terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-b3-vm3" {
  name     = "b3-vm3"
  location = "australiaeast"
}

resource "azurerm_virtual_network" "vn-b3-vm3" {
  name                = "b3-vm3"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-b3-vm3.location
  resource_group_name = azurerm_resource_group.rg-b3-vm3.name
}

resource "azurerm_subnet" "s-b3-vm3" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg-b3-vm3.name
  virtual_network_name = azurerm_virtual_network.vn-b3-vm3.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic-b3-vm3" {
  name                = "example"
  location            = azurerm_resource_group.rg-b3-vm3.location
  resource_group_name = azurerm_resource_group.rg-b3-vm3.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.s-b3-vm3.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ippub.id
  }
}

resource "azurerm_resource_group" "rg-pub2" {
  name     = "example-resources-pub2"
  location = "australiaeast"
}

resource "azurerm_public_ip" "ippub" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.rg-pub2.name
  location            = azurerm_resource_group.rg-pub2.location
  allocation_method   = "Static"
}


resource "azurerm_linux_virtual_machine" "vm-b3-vm3" {
  name                = "b3-vm3"
  resource_group_name = azurerm_resource_group.rg-b3-vm3.name
  location            = azurerm_resource_group.rg-b3-vm3.location
  size                = "Standard_B1s"
  admin_username      = "adm-user"

  custom_data = base64encode(data.local_file.cloudinit.content)

  network_interface_ids = [
    azurerm_network_interface.nic-b3-vm3.id,
  ]

  admin_ssh_key {
    username   = "adm-user"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
    // Data template Bash bootstrapping file
  data "local_file" "cloudinit" {
     filename = "cloud-init.yml"
  }
