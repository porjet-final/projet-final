#!/bin/bash

# Afficher le début du déploiement
echo "Début du déploiement"

# Se placer dans le dossier du projet
cd "$(dirname "$0")/.." || exit 1

# Récupérer les dernières modifications de GitHub
git pull --ff-only origin main || exit 1