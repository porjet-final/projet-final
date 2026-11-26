# Utiliser l'image officielle PHP avec Apache

FROM php:8.4-apache

# Copier les fichiers du site dans Apache
COPY site/ /var/www/html/

# Documenter le port HTTP utilisé par Apache
# Le port 8081 de la machine hôte sera redirigé vers ce port
EXPOSE 80