#!/bin/bash

# Vérifier si l'utilisateur est root
if [ "$EUID" -ne 0 ]; then
  echo "Veuillez exécuter ce script avec des privilèges root ou en utilisant sudo."
  exit 1
fi

# Mettre à jour les paquets et installer les dépendances requises
echo "Mise à jour des paquets et installation des dépendances..."
apt-get update -y
apt-get install -y ca-certificates curl gnupg lsb-release

# Ajouter la clé GPG officielle de Docker
echo "Ajout de la clé GPG officielle de Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Ajouter le dépôt Docker au gestionnaire de paquets
echo "Ajout du dépôt Docker au gestionnaire de paquets..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mettre à jour la liste des paquets
apt-get update -y

# Désinstaller les versions conflictuelles de Docker (le cas échéant)
echo "Suppression des versions conflictuelles de Docker..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  apt-get remove -y $pkg || true
done

# Installer Docker Engine
echo "Installation de Docker Engine..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Vérification de l'installation
echo "Vérification de l'installation..."
docker run hello-world

# Ajouter l'utilisateur courant au groupe Docker (optionnel)
echo "Ajout de l'utilisateur $(whoami) au groupe Docker..."
usermod -aG docker $(whoami)

# Message de fin
echo "Docker Engine a été installé avec succès ! Veuillez vous déconnecter et vous reconnecter pour que les changements prennent effet."
