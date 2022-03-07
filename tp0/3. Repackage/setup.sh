#!/bin/bash

# Ajout des dépôts EPEL
#sudo apt install -y epel-release

# Mise à jour du système
sudo apt update -y

# Installation d'un paquet
sudo apt install -y vim

# Installation Python (pour ansible)

sudo apt install python3.9

# Installation d'un paquet Ansible
sudo apt install -y ansible 

# On active la connexion au serveur SSH avec un mot de passe
# Ui c'est nul, mais on en a besoin ensuite
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Clean caches and artifacts
sudo rm -f /etc/udev/rules.d/70-persistent-net.rules # Normalement useless, mais au cas où
sudo apt clean all
sudo rm -rf /tmp/*
sudo rm -f /var/log/wtmp /var/log/btmp
sudo history -c
