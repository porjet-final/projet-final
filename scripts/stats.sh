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
# Lire le journal du conteneur et garder uniquement les lignes de requetes HTTP
LOGS=$(docker logs "$CONTAINER" 2>/dev/null | grep 'HTTP/')

# Si aucune ligne n'est trouvee, le site n'a recu aucune visite
if [ -z "$LOGS" ]; then
    # Afficher un message clair
    echo "Aucune visite enregistree pour le conteneur '$CONTAINER'."
    # Quitter avec un code d'erreur
    exit 1
fi

# Compter le nombre total de requetes (une par ligne)
NB_REQUETES=$(echo "$LOGS" | wc -l)

# Compter les erreurs 404 : le champ 9 contient le code de reponse
NB_404=$(echo "$LOGS" | cut -d' ' -f9 | grep -c '^404$')
# IP la plus active : champ 1, tri, comptage, tri decroissant, premiere ligne, deuxieme colonne
TOP_IP=$(echo "$LOGS" | cut -d' ' -f1 | sort | uniq -c | sort -rn | head -n 1 | awk '{print $2}')

# Page la plus demandee : champ 7, meme principe
TOP_PAGE=$(echo "$LOGS" | cut -d' ' -f7 | sort | uniq -c | sort -rn | head -n 1 | awk '{print $2}')

# Afficher le nombre total de requetes
echo "Requetes : $NB_REQUETES"

# Afficher le nombre d'erreurs 404
echo "Erreurs 404 : $NB_404"

# Afficher l'adresse IP la plus active
echo "IP la plus active : $TOP_IP"

# Afficher la page la plus demandee
echo "Page la plus demandee : $TOP_PAGE"
