#!/bin/bash
# Script d'analyse des journaux d'accès Apache dans Docker

# Définir le nom du conteneur : premier argument ou 'site' par défaut (bonus)
CONTAINER="${1:-site}"

# Vérifier si le conteneur existe et tourne, sinon afficher une erreur et quitter
if ! docker inspect "$CONTAINER" > /dev/null 2>&1; then
    # Afficher le message d'erreur explicite
    echo "Erreur : le conteneur '$CONTAINER' n'existe pas."
    # Quitter avec un code de retour en erreur
    exit 1
fi
