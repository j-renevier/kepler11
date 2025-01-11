#!/bin/bash

# Ce script installe Docker Engine sur Debian.
# Il nécessite les privilèges root ou sudo.

set -e

echo "==> Mise à jour des paquets et installation des dépendances..."
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "==> Ajout de la clé GPG officielle de Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "==> Ajout du dépôt officiel Docker au fichier sources.list..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "==> Mise à jour des dépôts et installation de Docker Engine..."
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> Vérification de l'installation de Docker avec l'image hello-world..."
sudo docker run hello-world

echo "==> Configuration pour exécuter Docker sans sudo (facultatif)..."
if ! groups | grep -q docker; then
    echo "Ajout de l'utilisateur $(whoami) au groupe docker..."
    sudo usermod -aG docker $(whoami)
    echo "Déconnectez-vous et reconnectez-vous pour appliquer les changements."
fi

echo "==> Docker a été installé avec succès!"
