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

resource "azurerm_resource_group" "rg-b3-vm-tp5" {
  name     = "b3-vm-tp5"
  location = "australiaeast"
}

resource "azurerm_virtual_network" "vn-b3-vm-tp5" {
  name                = "b3-vm-tp5"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-b3-vm-tp5.location
  resource_group_name = azurerm_resource_group.rg-b3-vm-tp5.name
}

resource "azurerm_subnet" "s-b3-vm-tp5" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg-b3-vm-tp5.name
  virtual_network_name = azurerm_virtual_network.vn-b3-vm-tp5.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic-b3-vm-tp5" {
  name                = "example"
  location            = azurerm_resource_group.rg-b3-vm-tp5.location
  resource_group_name = azurerm_resource_group.rg-b3-vm-tp5.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.s-b3-vm-tp5.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm-b3-vm-tp5" {
  name                = "b3-vm-tp5"
  resource_group_name = azurerm_resource_group.rg-b3-vm-tp5.name
  location            = azurerm_resource_group.rg-b3-vm-tp5.location
  size                = "Standard_B1s"
  admin_username      = "adm-user"
  network_interface_ids = [
    azurerm_network_interface.nic-b3-vm-tp5.id,
  ]

  admin_ssh_key {
    username   = "adm-user"
    public_key = file("~/.ssh/id_rsa_tp.pub")
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
