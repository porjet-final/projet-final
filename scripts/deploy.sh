#!/bin/bash

# Afficher le début du déploiement
echo "Début du déploiement"

# Se placer dans le dossier du projet
cd "$(dirname "$0")/.." || exit 1

# Récupérer les dernières modifications de GitHub
git pull --ff-only origin main ||  { echo "Échec de la récupération des modifications depuis GitHub"; exit 1; }

# Construire l'image Docker du projet
docker build -t projet-final . || { echo "Échec de la construction de l'image Docker"; exit 1; }

# Supprimer l'ancien conteneur s'il existe
docker rm -f site 2>/dev/null

# Lancer le nouveau conteneur Docker
docker run -d --name site -p 8081:80 projet-final || { echo "Échec du lancement du conteneur Docker"; exit 1; }

# Vérifier que le site répond
if curl -fsS --retry 5 --retry-connrefused http://localhost:8081 >/dev/null; then
    # Afficher un message de réussite
    echo "Déploiement réussi"
else
    # Afficher un message d'échec
    echo "Échec du déploiement"
    # Arrêter le script avec une erreur
    exit 1
fi
