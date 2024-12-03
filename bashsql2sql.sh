#!/bin/bash

# Fichier de configuration
CONFIG_FILE="config.txt"
LOG_FILE="transfer.log"
STATE_FILE="state.json"

# Fonction pour afficher le menu de langue
choose_language() {
  echo "Pour continuer en français, entrez [fr]."
  echo "To continue in English, enter [en]."
  read -p "Choisissez une langue : " LANG

  if [[ "$LANG" == "fr" ]]; then
    LANGUAGE="fr"
  elif [[ "$LANG" == "en" ]]; then
    LANGUAGE="en"
  else
    echo "Option invalide. Le programme s'exécutera en anglais par défaut."
    LANGUAGE="en"
  fi
}

# Fonction pour afficher les messages en fonction de la langue choisie
print_message() {
  if [[ "$LANGUAGE" == "fr" ]]; then
    echo "$1"
  else
    echo "$1"
  fi
}

# Demander la langue en premier
choose_language

# Passer en sudo
echo "Veuillez entrer votre mot de passe sudo pour effectuer les actions suivantes..."
sudo -v

# Fonction pour créer le fichier de configuration et demander les informations à l'utilisateur
create_config_file() {
  if [[ "$LANGUAGE" == "fr" ]]; then
    print_message "Le fichier de configuration '$CONFIG_FILE' est introuvable."
    print_message "Nous allons créer ce fichier. Veuillez entrer les informations suivantes."
  else
    print_message "The configuration file '$CONFIG_FILE' is missing."
    print_message "We will create this file. Please enter the following information."
  fi

  # Demander les informations pour la base de données source
  if [[ "$LANGUAGE" == "fr" ]]; then
    read -p "Hôte et port de la base de données source (ex: user@localhost:3306): " SOURCE_DB_INFO
    read -sp "Mot de passe de la base de données source: " SOURCE_DB_PASSWORD
  else
    read -p "Source database host and port (e.g., user@localhost:3306): " SOURCE_DB_INFO
    read -sp "Source database password: " SOURCE_DB_PASSWORD
  fi
  echo

  # Extraire l'utilisateur, l'hôte et le port de SOURCE_DB_INFO
  SOURCE_DB_USER=$(echo "$SOURCE_DB_INFO" | cut -d'@' -f1)
  SOURCE_DB_HOST_PORT=$(echo "$SOURCE_DB_INFO" | cut -d'@' -f2)
  SOURCE_DB_HOST=$(echo "$SOURCE_DB_HOST_PORT" | cut -d':' -f1)
  SOURCE_DB_PORT=$(echo "$SOURCE_DB_HOST_PORT" | cut -d':' -f2)

  read -p "Nom de la base de données source: " SOURCE_DB_NAME

  # Demander les informations pour la base de données cible
  if [[ "$LANGUAGE" == "fr" ]]; then
    read -p "Hôte et port de la base de données cible (ex: user@localhost:3306): " TARGET_DB_INFO
    read -sp "Mot de passe de la base de données cible: " TARGET_DB_PASSWORD
  else
    read -p "Target database host and port (e.g., user@localhost:3306): " TARGET_DB_INFO
    read -sp "Target database password: " TARGET_DB_PASSWORD
  fi
  echo

  # Extraire l'utilisateur, l'hôte et le port de TARGET_DB_INFO
  TARGET_DB_USER=$(echo "$TARGET_DB_INFO" | cut -d'@' -f1)
  TARGET_DB_HOST_PORT=$(echo "$TARGET_DB_INFO" | cut -d'@' -f2)
  TARGET_DB_HOST=$(echo "$TARGET_DB_HOST_PORT" | cut -d':' -f1)
  TARGET_DB_PORT=$(echo "$TARGET_DB_HOST_PORT" | cut -d':' -f2)

  read -p "Nom de la base de données cible: " TARGET_DB_NAME

  # Créer le fichier avec les valeurs fournies
  cat <<EOL > "$CONFIG_FILE"
SOURCE_DB_HOST=$SOURCE_DB_HOST
SOURCE_DB_USER=$SOURCE_DB_USER
SOURCE_DB_PASSWORD=$SOURCE_DB_PASSWORD
SOURCE_DB_NAME=$SOURCE_DB_NAME
SOURCE_DB_PORT=$SOURCE_DB_PORT

TARGET_DB_HOST=$TARGET_DB_HOST
TARGET_DB_USER=$TARGET_DB_USER
TARGET_DB_PASSWORD=$TARGET_DB_PASSWORD
TARGET_DB_NAME=$TARGET_DB_NAME
TARGET_DB_PORT=$TARGET_DB_PORT
EOL

  echo "Le fichier de configuration '$CONFIG_FILE' a été créé avec succès."
}

# Appeler la fonction pour créer le fichier de configuration
create_config_file

# Avertissement IP avec les variables de connexion
echo "############################################################"
echo "#                                                          #"
echo "#      AVERTISSEMENT / WARNING: Configuration IP            #"
echo "#                                                          #"
echo "############################################################"

warn_ip_configuration() {
  if [[ "$LANGUAGE" == "fr" ]]; then
    echo "AVERTISSEMENT : Assurez-vous que votre adresse IP locale est autorisée par le fournisseur de votre base de données."
    echo "La plupart des fournisseurs ne permettent pas les connexions distantes par défaut, et uniquement depuis localhost."
    echo "Vous devez également vous assurer que l'adresse IP de votre routeur est autorisée auprès de vos deux fournisseurs de bases de données."
    echo "Si votre adresse IP n'est pas autorisée, l'opération échouera. Vous pouvez vérifier votre IP locale en exécutant 'ip a' dans le terminal."
  else
    echo "WARNING: Ensure that your local IP address is authorized by your database provider."
    echo "Most providers do not allow remote connections by default, and only from localhost."
    echo "You must also ensure that the IP address of your router is authorized with both of your database providers."
    echo "If your IP address is not authorized, the operation will fail. You can check your local IP by running 'ip a' in the terminal."
  fi
}

# Appel de l'avertissement IP
warn_ip_configuration

# Affichage de la commande mysql avec les variables de connexion
echo "Si vous souhaitez vous connecter à la base de données source avec les informations fournies, utilisez la commande suivante :"
echo "   sudo mysql -h \$SOURCE_DB_HOST -P \$SOURCE_DB_PORT -u \$SOURCE_DB_USER -p"
echo "   Si le port de la base de données est différent de celui par défaut (3306), utilisez :"
echo "   sudo mysql -h \$SOURCE_DB_HOST -P \$SOURCE_DB_PORT -u \$SOURCE_DB_USER -p"

# Confirmation des informations saisies
if [[ "$LANGUAGE" == "fr" ]]; then
  echo "Les informations suivantes ont été saisies :"
else
  echo "The following information has been entered:"
fi

echo "Source DB Host: $SOURCE_DB_HOST"
echo "Source DB User: $SOURCE_DB_USER"
echo "Source DB Name: $SOURCE_DB_NAME"
echo "Source DB Port: $SOURCE_DB_PORT"

echo "Target DB Host: $TARGET_DB_HOST"
echo "Target DB User: $TARGET_DB_USER"
echo "Target DB Name: $TARGET_DB_NAME"
echo "Target DB Port: $TARGET_DB_PORT"


# Récupérer la liste des tables de la base source
echo "Récupération de la liste des tables de la base source..."
TABLES=$(mysql -h "$SOURCE_DB_HOST" -u "$SOURCE_DB_USER" -p"$SOURCE_DB_PASSWORD" -D "$SOURCE_DB_NAME" -e "SHOW TABLES;" | tail -n +2)

if [[ -z "$TABLES" ]]; then
  echo "Aucune table trouvée dans la base de données source ou une erreur s'est produite."
  exit 1
fi

# Affichage des tables récupérées pour vérification
echo "Tables disponibles dans la base source :"
echo "$TABLES"
echo "----------------------------"

# Parcourir les tables et les importer une par une
for TABLE in $TABLES; do
  echo "Importation de la table $TABLE..."

  # Exporter la table de la base source et l'importer dans la base cible
  mysqldump -h "$SOURCE_DB_HOST" -u "$SOURCE_DB_USER" -p"$SOURCE_DB_PASSWORD" "$SOURCE_DB_NAME" "$TABLE" | mysql -h "$TARGET_DB_HOST" -u "$TARGET_DB_USER" -p"$TARGET_DB_PASSWORD" "$TARGET_DB_NAME"
  
  if [ $? -eq 0 ]; then
    echo "Table $TABLE importée avec succès."
  else
    echo "Erreur lors de l'importation de la table $TABLE."
  fi
done

echo "Importation Finie."

# Supprimer définitivement le fichier de configuration pour protéger les informations
echo "Nous allons maintenant supprimer le fichier de configuration pour protéger vos informations de connexion."
sudo rm -f "$CONFIG_FILE"
echo "Le fichier '$CONFIG_FILE' a été supprimé avec succès."

