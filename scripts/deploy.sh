#!/bin/bash

# Afficher le début du déploiement
echo "Début du déploiement"

# Se placer dans le dossier du projet
cd "$(dirname "$0")/.." || exit 1

# Récupérer les dernières modifications de GitHub
git pull --ff-only origin main || exit 1

# Construire l'image Docker du projet
docker build -t projet-final . || exit 1

# Supprimer l'ancien conteneur s'il existe
docker rm -f site

# Lancer le nouveau conteneur Docker
docker run -d --name site -p 8081:80 projet-final || exit 1